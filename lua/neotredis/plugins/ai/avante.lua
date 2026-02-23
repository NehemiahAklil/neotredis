return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- Set this to "*" to always pull the latest release version
	build = "make", -- Note: If you are on Windows, this is different (see Avante docs)
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-mini/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		-- "folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	opts = {
		selection = {
			enabled = false,
			hint_display = "delayed",
		},
		provider = "copilot", -- Set Copilot as the main provider
		auto_suggestions_provider = "copilot",
		providers = {
			copilot = {
				-- GitHub Copilot supports multiple models now!
				-- Options include: "claude-3.7-sonnet", "claude-3.5-sonnet", "gpt-4o"
				model = "gemini-3-flash",
				endpoint = "https://api.githubcopilot.com",
				timeout = 30000, -- 30 seconds
			},
		},
		-- You can customize the behavior of the inline diffs here
		-- behaviour = {
		-- 	auto_suggestions = false, -- Set to true if you want Avante to generate ghost text
		-- 	auto_set_highlight_group = true,
		-- 	auto_set_keymaps = true,
		-- 	auto_apply_diff_after_generation = false,
		-- },
	},
}
