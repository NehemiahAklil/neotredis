return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && pnpm install",
	ft = "markdown",
	keys = {
		{ "<A-m>", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
	},
}
