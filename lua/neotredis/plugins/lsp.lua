return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "pyright", "gopls", "html", "ts_ls", "emmet_ls", "vue_ls", "lua_ls" },
				automatic_enable = false,
			},
		},
		{ "saghen/blink.cmp" },
	},
	opts = {
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
				-- prefix = "icons",               prefix = ""
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		},
	},
	config = function()
		require("mason").setup()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local bufopts = { noremap = true, silent = true, buffer = args.buf }

			-- Disable semantic tokens for ts_ls in Vue files to avoid conflicts
			if client and client.name == "ts_ls" and vim.bo.filetype == "vue" then
				client.server_capabilities.semanticTokensProvider = false
			end
			end,
		})
		-- Get Vue Language Server path from Mason
		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

		local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}

		-- Configure gopls
		local gopls_settings = {
			analyses = {
				unusedparams = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		}
		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = gopls_settings,
			},
		})

		-- Configure HTML
		vim.lsp.config("html", {
			capabilities = capabilities,
		})
		vim.lsp.config("pyright", {
			capabilities = capabilities,
		})
		-- Configure vtsls with Vue plugin
		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							vue_plugin,
						},
					},
				},
			},
			filetypes = tsserver_filetypes,
		})
		-- Configure ts_ls for Vue only: vue_ls delegates TS work to ts_ls
		-- via @vue/typescript-plugin (hybrid mode). Plain TS/JS goes to tsgo
		-- below, which does not yet support the TS plugin system Vue needs.
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			init_options = {
				plugins = {
					vue_plugin,
				},
			},
			filetypes = { "vue" },
		})

		-- Configure tsgo (TypeScript 7 / native Go port) for non-Vue TS/JS.
		-- Far lighter and faster than tsserver. Installed via:
		--   npm i -g @typescript/native-preview --prefix ~/.local
		local tsgo_bin = vim.fn.expand("~/.local/bin/tsgo")
		vim.lsp.config("tsgo", {
			cmd = { tsgo_bin, "--lsp", "--stdio" },
			capabilities = capabilities,
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
			root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
		})

		-- Configure emmet_ls
		vim.lsp.config("emmet_ls", {
			filetypes = { "html", "css", "template" },
		})

		-- Configure lua_ls (lazydev.nvim supplies nvim API / plugin library types)
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					codeLens = { enable = true },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		-- Configure vue_ls (renamed from volar)
		-- Note: On recent nvim-lspconfig, on_init is automatically configured
		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
			filetypes = { "vue" },
			settings = {
				vue = {
					complete = {
						casing = {
							props = "autoCamel",
						},
					},
					inlayHints = {
						destructuredProps = {
							enabled = true,
						},
						inlineHandlerLeading = {
							enabled = true,
						},
						missingProps = {
							enabled = true,
						},
						optionsWrapper = {
							enabled = true,
						},
						vBindShorthand = {
							enabled = true,
						},
					},
				},
			},
		})

		-- Enable all configured servers
		vim.lsp.enable({ "gopls", "html", "ts_ls", "tsgo", "emmet_ls", "vue_ls", "pyright", "lua_ls" })

		-- Set highlight group for Vue components
		vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })
	end,
}
