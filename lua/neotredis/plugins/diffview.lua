return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
	},
	opts = {},
	keys = {
		{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (working tree)" },
		{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
		{ "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo file history" },
		{ "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
	},
}
