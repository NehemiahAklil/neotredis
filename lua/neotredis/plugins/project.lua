return {
	"ahmedkhalf/project.nvim",
	opts = {
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod", "pubspec.yaml" },
	},
	keys = {
		{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "View project" },
	},
	config = function()
		require("project_nvim").setup({})
	end,
}
