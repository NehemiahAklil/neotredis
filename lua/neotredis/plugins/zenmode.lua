return {
	"Pocco81/true-zen.nvim",
	config = function()
		vim.keymap.set("n", "<leader>zn", ":TZNarrow<CR>", {})
		vim.keymap.set("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
		vim.keymap.set("n", "<leader>zf", ":TZFocus<CR>", {})
		vim.keymap.set("n", "<leader>zm", ":TZMinimalist<CR>", {})
		vim.keymap.set("n", "<leader>za", ":TZAtaraxis<CR>", {})
	end,
}
