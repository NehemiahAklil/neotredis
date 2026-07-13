local utils = require("neotredis.utils")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- File path utilities
vim.keymap.set("n", "<leader>yr", function()
	utils.copy_to_clipboard()
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>yR", function()
	utils.copy_to_clipboard(true)
end, { desc = "Copy path with line number" })

-- Color conversion magic
vim.keymap.set("n", "<leader>r", function()
	utils.replace_hex_with_HSL()
end, { desc = "Replace hex with HSL" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Claude Code usage (5h / weekly account limits). Calls the module directly
-- rather than `:ClaudeUsage` so it works regardless of whether lualine.nvim
-- (which also requires this module for its statusline component) has loaded
-- yet.
vim.keymap.set("n", "<leader>cu", function()
	require("neotredis.claude_usage").show()
end, { desc = "Claude usage (5h / weekly)" })
