-- sidekick.nvim, wired to the GitHub Copilot CLI (`copilot`, see
-- https://github.com/github/copilot-cli).
--
-- sidekick ships two halves: an AI CLI terminal and Copilot LSP "Next Edit
-- Suggestions". Only the CLI half is turned on here -- NES needs the
-- `copilot-language-server` binary plus a Copilot sign-in, and it is not
-- installed on this machine; see the `nes` note below for how to enable it.
--
-- Keymaps live under `<leader>k` ([K]opilot / side[K]ick) because the other AI
-- plugins already own their prefixes: `<leader>c*` claude_code.lua,
-- `<leader>a*` antigravity.lua, `<leader>o*` opencode.lua.

-- Every mapping pins `name = "copilot"` so sidekick never falls back to its
-- tool picker -- this config is single-tool by design. `<leader>ks` is the
-- escape hatch when another CLI is wanted.
local COPILOT = { name = "copilot" }

---@param opts? table extra sidekick.cli.Show fields merged over COPILOT
local function copilot_opts(opts)
	return vim.tbl_extend("force", {}, COPILOT, opts or {})
end

local sidekick = {
	"folke/sidekick.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = function()
		---@type sidekick.Config
		return {
			-- Requires `copilot-language-server` (mason: `copilot-language-server`,
			-- or npm `@github/copilot-language-server`) enabled via
			-- `vim.lsp.enable("copilot")`, then `:LspCopilotSignIn`. Flip this to
			-- `true` and add the `<tab>` mapping from the sidekick README once that
			-- is in place.
			nes = { enabled = false },
			copilot = {
				-- Without the LSP attached there is no status to report; the
				-- notifications would only ever be "not running" noise.
				status = { enabled = false },
			},
			cli = {
				watch = true, -- reload buffers the CLI edits on disk
				win = {
					layout = "right",
					split = {
						-- Columns, not a fraction (unlike `win.float`). Matches the
						-- ~35% pane opencode.lua uses, with 80 as the floor so the
						-- Copilot TUI stays readable on a narrow window.
						width = math.max(80, math.floor(vim.o.columns * 0.35)),
					},
					keys = {
						-- `<C-.>` is opencode.nvim's global terminal toggle
						-- (opencode.lua); leaving sidekick's own `<C-.>` = hide in
						-- place would mean the same chord does two different things
						-- depending on which terminal has focus. `q` / `<C-q>` still
						-- hide, `<C-z>` still blurs.
						hide_ctrl_dot = false,
					},
				},
				tools = {
					-- Left at defaults on purpose: sidekick ships the copilot
					-- recipe in `sk/cli/copilot.lua` (`cmd = { "copilot",
					-- "--banner" }`, plus `--resume` / `--continue`), and this
					-- table is deep-merged over it. Extra CLI flags or env vars
					-- would go here, e.g. `cmd = { "copilot", "--banner",
					-- "--model", "claude-sonnet-4.5" }`.
					copilot = {},
				},
				picker = "snacks",
			},
		}
	end,
	keys = {
		{
			"<leader>kk",
			function()
				require("sidekick.cli").toggle(copilot_opts({ focus = true }))
			end,
			desc = "Toggle Copilot CLI",
		},
		{
			"<A-k>",
			function()
				require("sidekick.cli").focus(COPILOT)
			end,
			mode = { "n", "x", "i", "t" },
			desc = "Switch focus to/from Copilot CLI",
		},
		{
			"<leader>kh",
			function()
				require("sidekick.cli").hide(COPILOT)
			end,
			desc = "Hide Copilot CLI",
		},
		{
			"<leader>kd",
			function()
				require("sidekick.cli").close(COPILOT)
			end,
			desc = "Detach Copilot CLI session",
		},
		{
			"<leader>ks",
			function()
				require("sidekick.cli").select({ filter = { installed = true }, focus = true })
			end,
			desc = "Select CLI tool (installed)",
		},
		-- Context senders. `{this}` resolves to the cursor position in a file
		-- buffer, or to the visual selection when one is active.
		{
			"<leader>kt",
			function()
				require("sidekick.cli").send(copilot_opts({ msg = "{this}" }))
			end,
			mode = { "n", "x" },
			desc = "Send this (cursor/selection) to Copilot",
		},
		{
			"<leader>kv",
			function()
				require("sidekick.cli").send(copilot_opts({ msg = "{selection}" }))
			end,
			mode = "x",
			desc = "Send selection to Copilot",
		},
		{
			"<leader>kb",
			function()
				require("sidekick.cli").send(copilot_opts({ msg = "{file}" }))
			end,
			desc = "Send current file to Copilot",
		},
		{
			"<leader>ke",
			function()
				require("sidekick.cli").send(copilot_opts({ msg = "{diagnostics}" }))
			end,
			desc = "Send buffer diagnostics to Copilot",
		},
		{
			"<leader>kp",
			function()
				-- The default callback sends to whatever session is current; the
				-- explicit cb keeps this pinned to copilot like the senders above.
				-- Signature is `fun(msg?: string, text?: sidekick.Text[])`.
				require("sidekick.cli").prompt(function(_, text)
					if text then
						require("sidekick.cli").send(copilot_opts({ text = text }))
					end
				end)
			end,
			mode = { "n", "x" },
			desc = "Select Copilot prompt",
		},
	},
	config = function(_, opts)
		require("sidekick").setup(opts)

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>k", group = "Copilot CLI (side[K]ick)" },
			})
		end
	end,
}

-- Snacks picker -> Copilot CLI. opencode.nvim already owns `<a-a>` in the
-- picker input (see opencode.lua), so this rides `<a-s>` instead. Lazy merges
-- this spec's `opts` with the snacks specs declared elsewhere.
local snacks_picker = {
	"folke/snacks.nvim",
	optional = true,
	opts = {
		picker = {
			actions = {
				sidekick_send = function(...)
					return require("sidekick.cli.picker.snacks").send(...)
				end,
			},
			win = {
				input = {
					keys = {
						["<a-s>"] = { "sidekick_send", mode = { "n", "i" } },
					},
				},
			},
		},
	},
}

return { sidekick, snacks_picker }
