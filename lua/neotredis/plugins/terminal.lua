return {
	"numToStr/FTerm.nvim",
	keys = {
		{ "<F2>", "<cmd>lua require('FTerm').toggle()<CR>" },
		{ "<F2>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<CR>", mode = "t" },
	},
	config = function()
		require("FTerm").setup({
			dimensions = {
				height = 0.98,
				width = 0.98,
			},
		})
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = "grey", bg = "none" })
	end,
}
