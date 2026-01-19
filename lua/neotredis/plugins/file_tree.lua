return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
			end,
			desc = "Explorer NeoTree",
		},
	},
	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,
	config = function()
		local neotree = require("neo-tree")
		local do_setcd = function(state)
			local p = state.tree:get_node().path
			print(p) -- show in command line
			vim.cmd(string.format('exec(":lcd %s")', p))
		end
		neotree.setup({
			sources = { "filesystem", "buffers", "git_status" },
			hide_root_node = true,
			retain_hidden_root_indent = false,
			enable_git_status = false,
			enable_modified_markers = false,
			use_popups_for_input = false, -- not floats for input
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			}, -- filesystem
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function(arg)
						vim.cmd([[
              setlocal relativenumber
            ]])
					end,
				},
			},
		})
	end,
}
-- return {
-- 	"nvim-neo-tree/neo-tree.nvim",
-- 	-- branch = "v3.x",
-- 	tag = "3.6",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 		"MunifTanjim/nui.nvim",
-- 		"nvim-tree/nvim-web-devicons",
-- 	},
-- 	-- lazy = false,
-- 	-- opts = {
-- 	-- 	close_if_last_window = true,
-- 	-- 	enable_git_status = true,
-- 	-- 	window = {
-- 	-- 		width = 30,
-- 	-- 	},
-- 	-- 	buffers = {
-- 	-- 		follow_current_file = {
-- 	-- 			enabled = true,
-- 	-- 			leave_dirs_open = true,
-- 	-- 		},
-- 	-- 	},
-- 	-- 	default_component_configs = {
-- 	-- 		indent = {
-- 	-- 			with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
-- 	-- 			expander_collapsed = "",
-- 	-- 			expander_expanded = "",
-- 	-- 			expander_highlight = "NeoTreeExpander",
-- 	-- 		},
-- 	-- 		git_status = {
-- 	-- 			symbols = {
-- 	-- 				unstaged = "󰄱",
-- 	-- 				staged = "󰱒",
-- 	-- 			},
-- 	-- 		},
-- 	-- 	},
-- 	-- },
-- 	config = function()
-- 		local neotree = require("neo-tree")
-- 		local do_setcd = function(state)
-- 			local p = state.tree:get_node().path
-- 			print(p) -- show in command line
-- 			vim.cmd(string.format('exec(":lcd %s")', p))
-- 		end
-- 		neotree.setup({
-- 			close_if_last_window = true,
-- 			enable_git_status = true,
-- 			window = {
-- 				width = 30,
-- 			},
-- 			buffers = {
-- 				follow_current_file = {
-- 					enabled = true,
-- 					leave_dirs_open = true,
-- 				},
-- 			},
-- 			default_component_configs = {
-- 				indent = {
-- 					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
-- 					expander_collapsed = "",
-- 					expander_expanded = "",
-- 					expander_highlight = "NeoTreeExpander",
-- 				},
-- 				git_status = {
-- 					symbols = {
-- 						unstaged = "󰄱",
-- 						staged = "󰱒",
-- 					},
-- 				},
-- 			},
-- 			commands = {
-- 				setcd = function(state)
-- 					do_setcd(state)
-- 				end,
-- 				find_files = function(state)
-- 					do_setcd(state)
-- 					require("telescope.builtin").find_files()
-- 				end,
-- 				grep = function(state)
-- 					do_setcd(state)
-- 					require("telescope.builtin").live_grep()
-- 				end,
-- 			},
-- 		})
-- 	end,
-- 	keys = {
-- 		{
-- 			"<leader>e",
-- 			"<Cmd>Neotree<CR>",
-- 		},
-- 		-- {
-- 		-- 	"<leader>e",
-- 		-- 	function()
-- 		-- 		-- require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
-- 		-- 		require("neo-tree.command").execute({ reveal = true })
-- 		-- 	end,
-- 		-- 	desc = "Explorer NeoTree (Root Dir)",
-- 		-- },
-- 	},
-- }
