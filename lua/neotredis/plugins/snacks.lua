return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = true },
		picker = { enabled = true },
		zen = { enabled = true },
		-- dashboard-nvim and FTerm.nvim still own these roles until Stage 4
		-- (PLAN.md) replaces them; enabling both here would double-fire on
		-- VimEnter / collide on toggle keymaps.
		dashboard = { enabled = false },
		terminal = { enabled = false },
	},
	keys = {
		{
			"<leader>zz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>zZ",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
	},
}
