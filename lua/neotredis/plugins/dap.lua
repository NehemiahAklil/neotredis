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
				-- mason-nvim-dap's own dap-adapter names, not raw mason
				-- package names (e.g. "python" <-> mason's "debugpy",
				-- "js" <-> mason's "js-debug-adapter").
				ensure_installed = { "python", "delve", "js" },
				automatic_installation = true,
			},
		},
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			config = function()
				local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
				require("dap-python").setup(debugpy_python)
			end,
		},
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			opts = {},
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
		{
			"<leader>dpm",
			function() require("dap-python").test_method() end,
			ft = "python",
			desc = "Debug Python: Test Method",
		},
		{
			"<leader>dpc",
			function() require("dap-python").test_class() end,
			ft = "python",
			desc = "Debug Python: Test Class",
		},
		{
			"<leader>dgt",
			function() require("dap-go").debug_test() end,
			ft = "go",
			desc = "Debug Go: Test",
		},
		{
			"<leader>dgl",
			function() require("dap-go").debug_last_test() end,
			ft = "go",
			desc = "Debug Go: Last Test",
		},
	},
	config = function()
		local dap = require("dap")

		-- vscode-js-debug is a single server that multiplexes every JS/TS
		-- runtime ("pwa-node", "pwa-chrome", ...) through the `type` field
		-- in each configuration — one adapter definition, reused as-is for
		-- Chrome (community-standard pattern, not a separate binary).
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
		dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file (node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file (tsx runtime, for .ts)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "npx",
					runtimeArgs = { "tsx" },
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process (--inspect)",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
			}
		end

		for _, language in ipairs({ "typescriptreact", "javascriptreact", "vue" }) do
			dap.configurations[language] = {
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome against dev server",
					url = function()
						return vim.fn.input("Dev server URL: ", "http://localhost:5173")
					end,
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
		end
	end,
}
