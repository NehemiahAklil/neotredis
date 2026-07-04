return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = { preset = "enter" },

		appearance = {
			kind_icons = {
				-- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
				Text = " ",
				Method = "󰆧",
				Function = "ƒ ",
				Constructor = " ",
				Field = "󰜢 ",
				Variable = " ",
				Constant = " ",
				Class = " ",
				Interface = "󰜰 ",
				Struct = " ",
				Enum = "了 ",
				EnumMember = " ",
				Module = "",
				Property = " ",
				Unit = " ",
				Value = "󰎠 ",
				Keyword = "󰌆 ",
				Snippet = " ",
				File = " ",
				Folder = " ",
				Color = " ",
			},
		},

		completion = {
			menu = {
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
				},
			},
		},

		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- suppresses duplicate lua_ls entries for nvim API/plugin types
				},
			},
		},
	},
}
