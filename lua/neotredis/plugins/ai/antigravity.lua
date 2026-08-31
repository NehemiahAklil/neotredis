-- Antigravity CLI, run through Snacks.terminal -- the exact same terminal
-- backend claudecode.nvim uses under the hood for Claude Code (see
-- claude_code.lua). Snacks creates its terminal buffers with
-- `nvim_create_buf(false, true)` (unlisted + scratch), which is what keeps
-- Claude's terminal off barbar's tabline for free; riding the same backend
-- gets Antigravity the identical behavior without a manual TermOpen hack.
--
-- No dependency on NakLast/antigravity-cli.nvim: that plugin's own `:term`
-- + hardcoded window management can't be told to unlist its buffer or use
-- Snacks, so it's dropped in favor of driving Snacks.terminal directly (the
-- same approach opencode.lua takes for opencode).
--
-- Keymaps mirror claude_code.lua's <leader>c* layout with the leading
-- letter swapped to `a` so the two tools don't collide:
--   cc -> ac (toggle), cb -> ab (send buffer/line), cs -> as (send selection)
local cmd = "agy"

---@type snacks.terminal.Opts
local snacks_terminal_opts = {
	win = {
		position = "right",
		-- Matches claudecode.nvim's default split_width_percentage (see
		-- claude_code.lua / claudecode/terminal.lua) so both tools' panes
		-- are the same width.
		width = 0.30,
	},
}

local function toggle()
	require("snacks.terminal").toggle(cmd, snacks_terminal_opts)
end

-- Sends an `@file lines:[..]` reference into the terminal, mirroring what
-- antigravity-cli.nvim's ask_selection() used to do.
local function send_reference()
	local mode = vim.fn.mode()
	local start_line, end_line

	if mode == "v" or mode == "V" or mode == "\22" then
		start_line = vim.fn.line("v")
		end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
	else
		start_line = vim.fn.line(".")
		end_line = start_line
	end

	local bufname = vim.api.nvim_buf_get_name(0)
	local identifier = bufname ~= "" and vim.fn.fnamemodify(bufname, ":.") or "unnamed"
	local text = start_line == end_line and string.format("@%s lines:[%d]", identifier, start_line)
		or string.format("@%s lines:[%d-%d]", identifier, start_line, end_line)

	local term = require("snacks.terminal").get(cmd, snacks_terminal_opts)
	if not term then
		return
	end
	if not term:win_valid() then
		term:show()
	end

	local chan = vim.bo[term.buf].channel
	if chan ~= 0 then
		vim.api.nvim_chan_send(chan, text .. "\n")
	end
	vim.cmd("startinsert")
end

return {
	"folke/snacks.nvim",
	init = function()
		vim.api.nvim_create_user_command("Antigravity", toggle, { desc = "Toggle Antigravity" })
	end,
	keys = {
		{ "<leader>ac", toggle, desc = "Toggle Antigravity" },
		{ "<leader>ab", send_reference, desc = "Send current line to Antigravity" },
		{ "<leader>as", send_reference, mode = "v", desc = "Send selection to Antigravity" },
	},
}
