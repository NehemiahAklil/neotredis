return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			notify_on_error = true,
			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				-- Conform will run multiple formatters sequentially
				python = { "autopep8", "isort" },
				-- python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofmt" },
				--
				yaml = { "yamlfmt", "yq", stop_after_first = true },
				json = { "prettier", "yq", stop_after_first = true },
			},
		})
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		vim.keymap.set("n", "<leader>cF", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
