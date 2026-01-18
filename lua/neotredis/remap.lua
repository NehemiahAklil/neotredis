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
