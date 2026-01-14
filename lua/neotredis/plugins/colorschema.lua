return {
	-- Kanagawa Theme
	{
		"rebelot/kanagawa.nvim",
		-- compile = false,             -- enable compiling the colorscheme
		-- undercurl = true,            -- enable undercurls
		-- commentStyle = { italic = true },
		-- functionStyle = {}, keywordStyle = { italic = true},
		-- statementStyle = { bold = true },
		-- typeStyle = {},
		-- transparent = false,         -- do not set background color
		-- dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
		-- terminalColors = true,       -- define vim.g.terminal_color_{0,17}
		-- colors = {                   -- add/modify theme and palette colors
		--     palette = {},
		--     theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
		-- },
		-- overrides = function(colors) -- add/modify highlights
		--     return {}
		-- end,
		theme = "dragon", -- Load "wave" theme
		background = { -- map the value of 'background' option to a theme
			dark = "dragon", -- try "dragon" !
			light = "lotus",
		},
		config = function()
			vim.cmd("colorscheme kanagawa-wave")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
	-- Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			-- vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme oxocarbon")
		end,
	},
	{
		"Shatur/neovim-ayu",
		config = function()
			require("ayu").setup({
				overrides = {
					LineNr = { fg = "#636A74" },
				},
			})
			vim.cmd("colorscheme ayu-dark")
		end,
	},
}
