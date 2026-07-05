return {
	"nvim-flutter/flutter-tools.nvim",
	ft = "dart",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- vim.ui.select (device/emulator picker) is covered by snacks.picker's
		-- ui_select option (see snacks.lua) — no dressing.nvim needed.
	},
	-- NOTE: flutter-tools manages dartls itself; do NOT configure it via
	-- nvim-lspconfig / lsp.lua (its own README warns against this).
	opts = {
		-- flutter is managed by mise; its PATH shim is only injected by the
		-- shell's `mise activate` hook, which Neovim may not inherit
		-- depending on how the terminal/session was started. Asking mise
		-- directly for the SDK root sidesteps that PATH dependency.
		flutter_lookup_cmd = "mise where flutter",
		debugger = {
			enabled = true,
		},
	},
	keys = {
		{ "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter: Run" },
		{ "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: Hot Restart" },
		{ "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter: Hot Reload" },
		{ "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: Quit" },
		{ "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: Devices" },
		{ "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: Emulators" },
		{ "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: Outline Toggle" },
		{ "<leader>FD", "<cmd>FlutterDevTools<cr>", desc = "Flutter: Dev Tools" },
	},
}
