return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			-- NOTE: the repo is miroshQa/debugmaster.nvim — the plugin's own
			-- README quickstart snippet has a bogus owner in the lazy.nvim
			-- spec ("MironPascalCaseFan/debugmaster.nvim"); don't copy it
			-- verbatim from upstream docs.
			"miroshQa/debugmaster.nvim",
			-- osv lets DEBUG mode be test-driven on this very Lua config
			-- without configuring any real language adapter first.
			dependencies = { "jbyuki/one-small-step-for-vimkind" },
			config = function()
				local dm = require("debugmaster")
				vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, {
					nowait = true,
					desc = "Toggle DEBUG mode",
				})
				dm.plugins.osv_integration.enabled = true
			end,
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "mason-org/mason.nvim" },
			opts = {
				-- Per-language adapters (debugpy, delve, js-debug-adapter,
				-- ...) get their `dap`-adapter-name entries added here in
				-- the PRs that wire each language up.
				ensure_installed = {},
				automatic_installation = true,
			},
		},
	},
	keys = {
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
		{ "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Conditional Breakpoint",
		},
		{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
	},
}
