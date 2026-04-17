return {
	"akinsho/git-conflict.nvim",
	version = "*",
	config = function()
		require("git-conflict").setup({
			default_mappings = true, -- Uses co, ct, cb, c0
			default_commands = true, -- Adds :GitConflictChooseTheir, etc.
			highlights = {
				-- You can override colors here if your colorscheme doesn't do it automatically
				current = "DiffAdd",
				incoming = "DiffChange",
			},
		})
	end,
}
