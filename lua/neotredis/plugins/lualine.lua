-- Defined once and reused in both `sections` (focused window) and
-- `inactive_sections` (unfocused windows) -- lualine renders those from two
-- separate tables, and without this in `inactive_sections` too the usage
-- indicator only showed up in whichever split happened to have focus (e.g.
-- it disappeared from a file's statusline the moment focus moved to the
-- Claude Code terminal split).
local claude_usage_component = {
	function()
		return require("neotredis.claude_usage").statusline()
	end,
	cond = function()
		return require("neotredis.claude_usage").statusline() ~= ""
	end,
	color = function()
		return require("neotredis.claude_usage").color()
	end,
}

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
			lualine_x = { claude_usage_component },
		},
		inactive_sections = {
			lualine_c = { "filename" },
			lualine_x = { "location", claude_usage_component },
		},
	},
}
