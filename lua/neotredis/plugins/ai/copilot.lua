return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = { enabled = false }, -- Disable if you don't want the inline ghost text
			panel = { enabled = false },
		})
	end,
}
