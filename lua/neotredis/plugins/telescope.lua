return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"ahmedkhalf/project.nvim",
	},

	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules" },
			},
		})
		require("telescope").load_extension("projects")
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope old files" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find git files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
	end,
}
