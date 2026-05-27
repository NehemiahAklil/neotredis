-- opencode.nvim - AI assistant integration for Neovim
return {
	"NickvanDyke/opencode.nvim",
	version = "*", -- Latest stable release
	lazy = false, -- Load immediately for best integration
	dependencies = {
		{
			"folke/snacks.nvim", -- Enhanced UI for input, picker, and terminal
			opts = {
				picker = {
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			server = {
				toggle = function()
					require("opencode.terminal").toggle("/home/archtreides/.opencode/bin/opencode --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
				start = function()
					require("opencode.terminal").open("/home/archtreides/.opencode/bin/opencode --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
			},
			lsp = {
				enabled = true,
			},
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		-- ============================================================================
		-- Keymaps
		-- ============================================================================

		-- Ask opencode with context (most common workflow)
		vim.keymap.set({ "n", "x" }, "<C-a>", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode about selection/cursor" })

		-- Select from prompt library, commands, or provider controls
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action (picker)" })

		-- Toggle opencode terminal
		vim.keymap.set({ "n", "t" }, "<C-.>", function()
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
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		-- Re-map increment/decrement to ask/select due to <C-a>/<C-x> overrides
		vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
		vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

		-- ============================================================================
		-- Which-Key Leader Mappings
		-- ============================================================================
		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode (with context)" })

		vim.keymap.set({ "n", "x" }, "<leader>oA", function()
			require("opencode").ask()
		end, { desc = "Ask opencode (empty)" })

		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			require("opencode").select()
		end, { desc = "Select opencode action" })

		vim.keymap.set("n", "<leader>ot", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode terminal" })

		vim.keymap.set("n", "<leader>ou", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<leader>od", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		vim.keymap.set("n", "<leader>og", function()
			require("opencode").command("session.first")
		end, { desc = "Jump to first message" })

		vim.keymap.set("n", "<leader>oG", function()
			require("opencode").command("session.last")
		end, { desc = "Jump to last message" })

		vim.keymap.set("n", "<leader>on", function()
			require("opencode").command("session.new")
		end, { desc = "New opencode session" })

		vim.keymap.set("n", "<leader>oi", function()
			require("opencode").command("session.interrupt")
		end, { desc = "Interrupt opencode session" })

		vim.keymap.set("n", "<leader>oc", function()
			require("opencode").command("session.compact")
		end, { desc = "Compact opencode session" })

		vim.keymap.set("n", "<leader>oz", function()
			require("opencode").command("session.undo")
		end, { desc = "Undo in opencode session" })

		vim.keymap.set("n", "<leader>or", function()
			require("opencode").command("session.redo")
		end, { desc = "Redo in opencode session" })

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>o", group = "[O]pencode" },
			})
		end
	end,
}
