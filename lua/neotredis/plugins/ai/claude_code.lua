return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
			window = {
				position = "botright",      -- horizontal split at bottom for more vertical space
				split_ratio = 0.45,         -- 45% of screen height
				enter_insert = true,
				start_in_normal_mode = false,
				hide_numbers = true,
				hide_signcolumn = true,
			},
			refresh = {
				enable = true,
				updatetime = 100,
				timer_interval = 1000,
				show_notifications = false,
			},
			git = {
				use_git_root = true,
				multi_instance = true,
			},
			keymaps = {
				toggle = {
					normal = "<leader>cc",  -- no conflict with opencode's <leader>o* maps
					terminal = "<C-,>",     -- easy from terminal; opencode uses <C-.>
					variants = {
						continue = "<leader>cC",
						verbose = "<leader>cV",
					},
				},
				window_navigation = true,
				scrolling = true,
			},
		})

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>c", group = "[C]laude" },
			})
		end
	end,
}
