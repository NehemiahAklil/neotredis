-- opencode.nvim - AI assistant integration for Neovim
-- Full-featured setup with snacks.nvim integration
-- See: https://github.com/NickvanDyke/opencode.nvim
return {
	"NickvanDyke/opencode.nvim",
	lazy = false, -- Load immediately for best integration
	dependencies = {
		"folke/snacks.nvim", -- Enhanced UI for input, picker, and terminal
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Port configuration (nil = auto-discover from CWD)
			port = nil,

			-- Context placeholders for prompts
			-- All default contexts are enabled (@this, @buffer, @diagnostics, etc.)
			-- Use @grapple if you have grapple.nvim installed for tagged files
			contexts = {
				-- Defaults are automatically included
				-- You can add custom contexts here or disable defaults by setting to false
				-- Example: ["@custom"] = function(context) return "custom content" end
			},

			-- Built-in prompt library
			-- Access via <leader>ox or require('opencode').select()
			prompts = {
				-- All defaults included, plus some useful extras:
				-- ask_append - Insert context mid-prompt (handy for @this, @buffer, etc.)
				-- ask_this - Quick ask with auto-submit
				-- diagnostics - Explain LSP diagnostics
				-- diff - Review git diff
				-- document - Add documentation comments
				-- explain - Explain code and context
				-- fix - Fix diagnostics
				-- implement - Implement TODO/stub
				-- optimize - Optimize for performance
				-- review - Review for correctness
				-- test - Add tests
			},

			-- Enhanced ask() with snacks.nvim
			ask = {
				prompt = "Ask opencode: ",
				-- Enable blink.cmp sources for context autocomplete
				blink_cmp_sources = { "opencode", "buffer" },
				-- Snacks input configuration
				snacks = {
					icon = "󰚩 ", -- opencode icon
					win = {
						title_pos = "left",
						relative = "cursor",
						row = -3, -- Above cursor
						col = 0, -- Aligned with cursor
						width = 60,
						border = "rounded",
					},
				},
			},

			-- Enhanced select() with snacks.nvim
			select = {
				prompt = "opencode: ",
				sections = {
					prompts = true, -- Show all prompts
					commands = {
						-- Session management
						["session.new"] = "Start a new session",
						["session.share"] = "Share the current session",
						["session.interrupt"] = "Interrupt the current session",
						["session.compact"] = "Compact the current session (reduce context size)",
						["session.undo"] = "Undo the last action in the current session",
						["session.redo"] = "Redo the last undone action in the current session",
						-- Agent and prompt controls
						["agent.cycle"] = "Cycle the selected agent",
						["prompt.submit"] = "Submit the current prompt",
						["prompt.clear"] = "Clear the current prompt",
					},
					provider = true, -- Show provider controls (start/stop/toggle)
				},
				-- Snacks picker configuration
				snacks = {
					preview = "preview", -- Enable preview pane
					layout = {
						preset = "vscode", -- VSCode-like layout
						hidden = {}, -- Preview visible by default
					},
				},
			},

			-- Event handling
			events = {
				enabled = true,
				reload = true, -- Auto-reload buffers when opencode edits them
				permissions = {
					enabled = true, -- Handle permission requests
					idle_delay_ms = 1000, -- Wait 1s after idle before prompting
				},
			},

			-- Provider configuration for managing opencode
			provider = {
				enabled = "snacks", -- Use tmux for terminal experience
				-- enabled = "tmux", -- Use tmux for terminal experience
				cmd = "opencode --port", -- Base command (port auto-appended)
				snacks = {
					auto_close = true, -- Close terminal when opencode exits
					win = {
						position = "right", -- Vertical split on the right
						width = 0.27, -- 27% of screen width
						enter = true, -- Keep focus in editor
						border = "rounded",
						wo = {
							winbar = "", -- No winbar (opencode TUI has its own footer)
						},
						bo = {
							filetype = "opencode_terminal", -- Custom filetype for targeting
						},
					},
				},
				-- Alternative: tmux provider (if you prefer tmux over snacks terminal)
				-- Uncomment below and set enabled = 'tmux' to use tmux instead
				-- tmux = {
				-- 	options = "-h -p 28", -- Horizontal split (vertical pane), 28% width
				-- },
			},
		}

		-- ============================================================================
		-- Keymaps
		-- ============================================================================

		-- Ask opencode with context (most common workflow)
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode about selection/cursor" })

		-- Ask opencode (empty prompt, no auto-submit)
		vim.keymap.set({ "n", "x" }, "<leader>oA", function()
			require("opencode").ask()
		end, { desc = "Ask opencode (empty prompt)" })

		-- Select from prompt library, commands, or provider controls
		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			require("opencode").select()
		end, { desc = "Execute opencode action (picker)" })

		-- Toggle opencode terminal
		vim.keymap.set({ "n", "t" }, "<leader>ot", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode terminal" })

		-- Operator mapping for Vim-style workflows
		-- Usage: go{motion} to add range to opencode
		-- Examples: goip (paragraph), goi{ (block), go5j (5 lines)
		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		-- Operator for current line (double 'o')
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add current line to opencode", expr = true })

		-- Scroll opencode output from Neovim
		vim.keymap.set("n", "<leader>ou", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<leader>od", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		-- Jump to first/last message in session
		vim.keymap.set("n", "<leader>og", function()
			require("opencode").command("session.first")
		end, { desc = "Jump to first message" })

		vim.keymap.set("n", "<leader>oG", function()
			require("opencode").command("session.last")
		end, { desc = "Jump to last message" })

		-- Session management
		vim.keymap.set("n", "<leader>on", function()
			require("opencode").command("session.new")
		end, { desc = "New opencode session" })

		vim.keymap.set("n", "<leader>oi", function()
			require("opencode").command("session.interrupt")
		end, { desc = "Interrupt opencode session" })

		vim.keymap.set("n", "<leader>oc", function()
			require("opencode").command("session.compact")
		end, { desc = "Compact opencode session" })

		-- Undo/Redo in opencode session
		vim.keymap.set("n", "<leader>ou", function()
			require("opencode").command("session.undo")
		end, { desc = "Undo in opencode session" })

		vim.keymap.set("n", "<leader>or", function()
			require("opencode").command("session.redo")
		end, { desc = "Redo in opencode session" })

		-- Which-key integration for better discoverability
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>o", group = "[O]pencode" },
				{ "<leader>oa", desc = "Ask (with context)" },
				{ "<leader>oA", desc = "Ask (empty)" },
				{ "<leader>ox", desc = "Select action" },
				{ "<leader>ot", desc = "Toggle terminal" },
				{ "<leader>ou", desc = "Scroll up" },
				{ "<leader>od", desc = "Scroll down" },
				{ "<leader>og", desc = "Jump to first" },
				{ "<leader>oG", desc = "Jump to last" },
				{ "<leader>on", desc = "New session" },
				{ "<leader>oi", desc = "Interrupt" },
				{ "<leader>oc", desc = "Compact session" },
			})
		end
	end,
}
