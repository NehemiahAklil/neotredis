return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		close_if_last_window = true,
		enable_git_status = true,
		window = {
			width = 30,
		},
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
	},
	keys = {
		{
			"<leader>e",
			"<Cmd>Neotree<CR>",
		},
		-- {
		-- 	"<leader>e",
		-- 	function()
		-- 		-- require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
		-- 		require("neo-tree.command").execute({ reveal = true })
		-- 	end,
		-- 	desc = "Explorer NeoTree (Root Dir)",
		-- },
	},
}
