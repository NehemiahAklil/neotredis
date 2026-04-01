local TheNeotredisGroup = vim.api.nvim_create_augroup("TheNeotredis", {})
local autocmd = vim.api.nvim_create_autocmd

-- Vue context-aware commenting: detect embedded language at cursor and set correct commentstring
local vue_commentstrings = {
	vue = "<!-- %s -->",
	html = "<!-- %s -->",
	javascript = "// %s",
	typescript = "// %s",
	css = "/* %s */",
	scss = "// %s",
}

local function update_vue_commentstring()
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok or not parser then
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	local lang_tree = parser:language_for_range({ row, col, row, col })
	if lang_tree then
		local lang = lang_tree:lang()
		if vue_commentstrings[lang] then
			vim.bo.commentstring = vue_commentstrings[lang]
		end
	end
end

autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = TheNeotredisGroup,
	pattern = "*.vue",
	callback = update_vue_commentstring,
})

autocmd({ "BufWritePre" }, {
	group = TheNeotredisGroup,
	pattern = "*",
	command = [[%s/\s+$//e]],
})

autocmd("LspAttach", {
	group = TheNeotredisGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "gi", function()
			vim.lsp.buf.implementation()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("n", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "<[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "<]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})
