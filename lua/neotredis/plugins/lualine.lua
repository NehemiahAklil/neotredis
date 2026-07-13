return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "ayu",
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				{
					function()
						return require("neotredis.claude_usage").statusline()
					end,
					cond = function()
						return require("neotredis.claude_usage").statusline() ~= ""
					end,
					color = function()
						return require("neotredis.claude_usage").color()
					end,
				},
			},
		},
	},
}
