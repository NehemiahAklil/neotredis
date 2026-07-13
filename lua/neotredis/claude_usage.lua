-- Shows the *real* Claude Code account rate-limit usage (5-hour session
-- window and 7-day weekly window) in the statusline and via `:ClaudeUsage`.
--
-- This reads Anthropic's own OAuth usage endpoint -- the same source Claude
-- Code's built-in statusline and `/usage` command use -- rather than
-- estimating token counts from local JSONL transcripts (which is all
-- log-parsing tools like ccusage can do, and which can't reflect the actual
-- account limit percentage).
--
-- That endpoint is known to 429 aggressively under frequent polling
-- (anthropics/claude-code#31637, #31021) -- confirmed in practice, not just
-- theory: this account got 429'd during development. So on a 429 we back off
-- exponentially (5m, 10m, 20m, ... capped at 30m) instead of hammering it on
-- a fixed interval, and the lualine component shows a distinct "429"
-- indicator rather than going silently blank, so a persistent throttle
-- doesn't look identical to "not working". The component still only ever
-- reads the cache -- it never makes a network call on the redraw path.

local M = {}

local REFRESH_MS = 5 * 60 * 1000 -- base background poll interval
local MAX_BACKOFF_MS = 30 * 60 * 1000 -- cap for 429 backoff
local MIN_ATTEMPT_GAP_S = 30 -- floor between any two network attempts, manual or scheduled
local CREDENTIALS_PATH = vim.fn.expand("~/.claude/.credentials.json")
local USAGE_URL = "https://api.anthropic.com/api/oauth/usage"

local cache = {
	text = "",
	five_hour = nil, -- { utilization = <0-100>, resets_at = <iso8601> }
	weekly = nil,
	fetched_at = 0, -- last *successful* fetch
	last_attempt_at = 0, -- last attempt, successful or not
	fetching = false,
	pending_callback = nil,
	last_error = nil,
}

local timer = nil
local started = false
local consecutive_429s = 0

local function read_token()
	if vim.fn.filereadable(CREDENTIALS_PATH) == 0 then
		return nil
	end
	local ok, lines = pcall(vim.fn.readfile, CREDENTIALS_PATH)
	if not ok or not lines or #lines == 0 then
		return nil
	end
	local ok2, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not ok2 or type(decoded) ~= "table" then
		return nil
	end
	return decoded.claudeAiOauth and decoded.claudeAiOauth.accessToken or nil
end

-- Converts an ISO-8601 UTC timestamp ("2026-07-13T14:40:00.09Z" or
-- "...+00:00") to a Unix epoch. os.time() assumes the table it's given is
-- local time, so we measure the local/UTC skew and shift by it.
local function iso_to_epoch(iso)
	if not iso then
		return nil
	end
	local y, mo, d, h, mi, s = iso:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
	if not y then
		return nil
	end
	local t = {
		year = tonumber(y),
		month = tonumber(mo),
		day = tonumber(d),
		hour = tonumber(h),
		min = tonumber(mi),
		sec = tonumber(s),
	}
	local as_local = os.time(t)
	local skew = os.difftime(as_local, os.time(os.date("!*t", as_local)))
	return as_local + skew
end

local function format_countdown(epoch)
	if not epoch then
		return "?"
	end
	local secs = epoch - os.time()
	if secs <= 0 then
		return "now"
	end
	local h = math.floor(secs / 3600)
	local m = math.floor((secs % 3600) / 60)
	if h > 0 then
		return string.format("%dh%02dm", h, m)
	end
	return string.format("%dm", m)
end

local function severity_group(pct)
	if pct == nil then
		return "Comment"
	elseif pct >= 90 then
		return "DiagnosticError"
	elseif pct >= 70 then
		return "DiagnosticWarn"
	else
		return "DiagnosticOk"
	end
end

-- Renders the lualine text. Real data always wins once we have it (even if
-- the *latest* refresh attempt failed -- stale-but-real beats no data). Only
-- falls back to an error placeholder before the first successful fetch, and
-- stays silent when there's genuinely nothing to show (not logged in).
local function update_display()
	if cache.five_hour and cache.weekly then
		cache.text = string.format(
			"🤖 5h:%d%% wk:%d%%",
			math.floor(cache.five_hour.utilization + 0.5),
			math.floor(cache.weekly.utilization + 0.5)
		)
	elseif not cache.last_error then
		cache.text = ""
	elseif cache.last_error:match("^not logged in") then
		cache.text = ""
	elseif cache.last_error:match("429") then
		cache.text = "🤖 429"
	else
		cache.text = "🤖 …"
	end
end

local function on_response(res)
	cache.fetching = false
	if res.code ~= 0 or not res.stdout or res.stdout == "" then
		cache.last_error = "curl failed (exit " .. tostring(res.code) .. ")"
		update_display()
		return
	end
	local body, status = res.stdout:match("^(.*)\n(%d+)%s*$")
	if not status then
		cache.last_error = "unexpected curl output"
		update_display()
		return
	end
	if status == "429" then
		cache.last_error = "rate limited by Anthropic (429)"
		update_display()
		return
	end
	if status ~= "200" then
		cache.last_error = "HTTP " .. status
		update_display()
		return
	end
	local ok, decoded = pcall(vim.json.decode, body)
	if not ok or type(decoded) ~= "table" or not decoded.five_hour or not decoded.seven_day then
		cache.last_error = "bad response body"
		update_display()
		return
	end
	cache.five_hour = decoded.five_hour
	cache.weekly = decoded.seven_day
	cache.fetched_at = os.time()
	cache.last_error = nil
	update_display()
end

-- At most one curl call is ever outstanding, and attempts (manual or
-- scheduled) are floored to one per MIN_ATTEMPT_GAP_S -- the background
-- scheduler already paces itself well above that floor via backoff, so this
-- floor mainly protects against `:ClaudeUsage` being mashed while throttled.
local function fetch(callback)
	if (os.time() - cache.last_attempt_at) < MIN_ATTEMPT_GAP_S then
		if callback then
			callback()
		end
		return
	end
	if cache.fetching then
		if callback then
			cache.pending_callback = callback
		end
		return
	end
	local token = read_token()
	if not token then
		cache.last_error = "not logged in (no ~/.claude/.credentials.json)"
		update_display()
		if callback then
			callback()
		end
		return
	end
	cache.fetching = true
	cache.last_attempt_at = os.time()
	vim.system({
		"curl",
		"-s",
		"--max-time",
		"10",
		"-H",
		"Authorization: Bearer " .. token,
		"-H",
		"anthropic-beta: oauth-2025-04-20",
		"-w",
		"\n%{http_code}",
		USAGE_URL,
	}, { text = true }, function(res)
		vim.schedule(function()
			on_response(res)
			local cb = callback
			callback = nil
			if cb then
				cb()
			end
			if cache.pending_callback then
				local pending = cache.pending_callback
				cache.pending_callback = nil
				pending()
			end
		end)
	end)
end

local function schedule_next(delay_ms)
	if timer then
		timer:stop()
		timer:close()
	end
	timer = (vim.uv or vim.loop).new_timer()
	timer:start(
		delay_ms,
		0,
		vim.schedule_wrap(function()
			fetch(function()
				local next_delay
				if cache.last_error and cache.last_error:match("429") then
					consecutive_429s = consecutive_429s + 1
					next_delay = math.min(REFRESH_MS * (2 ^ consecutive_429s), MAX_BACKOFF_MS)
				else
					consecutive_429s = 0
					next_delay = REFRESH_MS
				end
				schedule_next(next_delay)
			end)
		end)
	)
end

local function ensure_timer()
	if started then
		return
	end
	started = true
	schedule_next(0)
end

--- Lualine component: returns the cached display string. Never blocks and
--- never makes a network call -- safe to call on every redraw.
function M.statusline()
	ensure_timer()
	return cache.text
end

--- Lualine `color` field: tints the component by whichever of the two
--- windows is closer to its limit, reusing the built-in Diagnostic* colors.
--- Falls back to a dim `Comment` tint for the "429"/pending placeholders.
function M.color()
	if not cache.text or cache.text == "" then
		return {}
	end
	local group
	if cache.five_hour and cache.weekly then
		group = severity_group(math.max(cache.five_hour.utilization, cache.weekly.utilization))
	else
		group = "Comment"
	end
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if ok and hl and hl.fg then
		return { fg = string.format("#%06x", hl.fg) }
	end
	return {}
end

--- `:ClaudeUsage` -- forces a refresh (subject to the same rate-limit floor
--- as the background timer) and notifies with both windows and their reset
--- countdowns.
function M.show()
	fetch(function()
		if not cache.five_hour or not cache.weekly then
			vim.notify(
				"Claude usage unavailable" .. (cache.last_error and (": " .. cache.last_error) or ""),
				vim.log.levels.WARN,
				{ title = "Claude Usage" }
			)
			return
		end
		local lines = {
			string.format(
				"Session (5h): %d%%  resets in %s",
				math.floor(cache.five_hour.utilization + 0.5),
				format_countdown(iso_to_epoch(cache.five_hour.resets_at))
			),
			string.format(
				"Weekly (7d):  %d%%  resets in %s",
				math.floor(cache.weekly.utilization + 0.5),
				format_countdown(iso_to_epoch(cache.weekly.resets_at))
			),
		}
		if cache.last_error then
			table.insert(lines, "(latest refresh: " .. cache.last_error .. ")")
		end
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Claude Usage" })
	end)
end

vim.api.nvim_create_user_command("ClaudeUsage", function()
	M.show()
end, { desc = "Show Claude Code 5-hour and weekly usage limits" })

ensure_timer()

return M
