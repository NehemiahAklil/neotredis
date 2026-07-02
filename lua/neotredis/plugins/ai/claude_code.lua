-- Icons/highlight groups are purely cosmetic. The `Diagnostic*` groups are
-- built into Neovim core, so no icon-font or extra plugin is required.
local models = {
	{ name = "Claude Opus (Latest)", value = "opus", icon = "★", hl = "DiagnosticError" },
	{ name = "Claude Opus (Latest, 1M context)", value = "opus[1m]", icon = "★", hl = "DiagnosticError" },
	{ name = "Claude Sonnet (Latest)", value = "sonnet", icon = "◆", hl = "DiagnosticWarn" },
	{ name = "Claude Sonnet (Latest, 1M context)", value = "sonnet[1m]", icon = "◆", hl = "DiagnosticWarn" },
	{ name = "Claude Haiku (Latest)", value = "haiku", icon = "●", hl = "DiagnosticOk" },
	{ name = "Default (account recommended)", value = "default", icon = "○", hl = "Comment" },
}

-- `/effort <level>` is a Claude Code in-chat command; there's no plugin-side
-- config table for it (unlike `models`), so the level list lives here. Icons
-- form a rising "meter" (low -> max) paired with a green -> red gradient so
-- the picker reads at a glance.
local efforts = {
	{ name = "Low", value = "low", icon = "▁", hl = "DiagnosticOk" },
	{ name = "Medium", value = "medium", icon = "▃", hl = "DiagnosticHint" },
	{ name = "High", value = "high", icon = "▅", hl = "DiagnosticWarn" },
	{ name = "Extra High", value = "xhigh", icon = "▇", hl = "DiagnosticError" },
	{ name = "Max", value = "max", icon = "█", hl = "DiagnosticError" },
}

-- Renders `<icon colored> <name>` as highlighted chunks (Snacks.picker's
-- ui_select formatter accepts a chunk list, not just a plain string).
local function format_entry(item)
	return {
		{ (item.icon or "-") .. " ", item.hl or "SnacksPickerLabel" },
		{ item.name },
	}
end

-- Both pickers are called from terminal mode (see `snacks_win_opts.keys`
-- below), so opening them never sends an <Esc> byte to the Claude pty --
-- unlike leaving terminal mode by hand, it can't cancel a response that's
-- currently streaming. The pick is sent as a fully-specified `/model <name>`
-- / `/effort <level>` in-chat command rather than relaunched via `claude
-- --model`/`--effort`, since claudecode.nvim just reuses/hides the existing
-- terminal and silently drops those flags once a session is already running.
-- Note: like any in-chat command, it's only processed once Claude is idle at
-- the prompt -- there's no way to switch model/effort mid-stream, in this
-- plugin or in Claude Code itself.
local function select_model()
	local models_list = require("claudecode").state.config.models
	if not models_list or #models_list == 0 then
		vim.notify("No Claude models configured", vim.log.levels.WARN)
		return
	end

	Snacks.picker.select(models_list, {
		prompt = "Claude Model",
		format_item = format_entry,
		snacks = {
			title = "✨ Claude Model",
			layout = { preset = "select", layout = { border = "rounded", max_width = 56 } },
		},
	}, function(choice)
		if not choice then
			return
		end
		vim.cmd("ClaudeCodeSendText /model " .. choice.value)
	end)
end

local function select_effort()
	Snacks.picker.select(efforts, {
		prompt = "Claude Effort",
		format_item = format_entry,
		snacks = {
			title = "⚡ Claude Effort",
			layout = { preset = "select", layout = { border = "rounded", max_width = 56 } },
		},
	}, function(choice)
		if not choice then
			return
		end
		vim.cmd("ClaudeCodeSendText /effort " .. choice.value)
	end)
end

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		require("claudecode").setup({
			models = models,
			terminal = {
				snacks_win_opts = {
					keys = {
						-- <C-m>/<C-e> are skipped: <C-m> is the same keycode as <CR>
						-- and would hijack Enter for the whole terminal.
						claude_select_model = {
							"<M-m>",
							select_model,
							mode = "t",
							desc = "Select Claude model (in-chat)",
						},
						claude_select_effort = {
							"<M-e>",
							select_effort,
							mode = "t",
							desc = "Select Claude effort (in-chat)",
						},
					},
				},
			},
		})
	end,
	-- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
	-- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
	-- spec defers loading until a <leader>a* mapping is pressed and the commands
	-- would not exist yet.
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffs",
	},
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>cs",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
		},
		-- Diff management
		{ "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
-- return {
-- 	"greggh/claude-code.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 	},
-- 	config = function()
-- 		require("claude-code").setup({
-- 			window = {
-- 				position = "botright",      -- horizontal split at bottom for more vertical space
-- 				split_ratio = 0.45,         -- 45% of screen height
-- 				enter_insert = true,
-- 				start_in_normal_mode = false,
-- 				hide_numbers = true,
-- 				hide_signcolumn = true,
-- 			},
-- 			refresh = {
-- 				enable = true,
-- 				updatetime = 100,
-- 				timer_interval = 1000,
-- 				show_notifications = false,
-- 			},
-- 			git = {
-- 				use_git_root = true,
-- 				multi_instance = true,
-- 			},
-- 			keymaps = {
-- 				toggle = {
-- 					normal = "<leader>cc",  -- no conflict with opencode's <leader>o* maps
-- 					terminal = "<C-,>",     -- easy from terminal; opencode uses <C-.>
-- 					variants = {
-- 						continue = "<leader>cC",
-- 						verbose = "<leader>cV",
-- 					},
-- 				},
-- 				window_navigation = true,
-- 				scrolling = true,
-- 			},
-- 		})
--
-- 		local ok, wk = pcall(require, "which-key")
-- 		if ok then
-- 			wk.add({
-- 				{ "<leader>c", group = "[C]laude" },
-- 			})
-- 		end
-- 	end,
-- }
