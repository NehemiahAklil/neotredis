return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	-- keys = {
	--     { "zR", "<cmd>lua require('ufo').openAllFolds<CR>"},
	--     { "zM", "<cmd>lua require('ufo').closeAllFolds<CR>"},
	-- },
	-- opts = {
	-- 	provider_selector = function(bufnr, filetype, buftype)
	-- 		return { "treesitter", "indent" }
	-- 	end,
	-- },
	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		-- use Neovim nightly branch
		-- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'

		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		-- Option 2: nvim lsp as LSP client
		-- Tell the server the capability of foldingRange,
		-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities.textDocument.foldingRange = {
		-- 	dynamicRegistration = false,
		-- 	lineFoldingOnly = true,
		-- }
		-- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
		-- for _, ls in ipairs(language_servers) do
		-- 	require("lspconfig")[ls].setup({
		-- 		capabilities = capabilities,
		-- 		-- you can add other fields for setting up lsp server in this table
		-- 	})
		-- end

		-- Option 3: treesitter as a main provider instead
		-- (Note: the `nvim-treesitter` plugin is *not* needed.)
		-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
		-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
		require("ufo").setup()
	end,
}
