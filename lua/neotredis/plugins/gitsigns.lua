return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Hunk navigation (respects diff mode).
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Gitsigns: next hunk")
			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Gitsigns: prev hunk")

			-- Stage / reset.
			map("n", "<leader>hs", gs.stage_hunk, "Gitsigns: stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Gitsigns: reset hunk")
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Gitsigns: stage selected hunk")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Gitsigns: reset selected hunk")
			map("n", "<leader>hS", gs.stage_buffer, "Gitsigns: stage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "Gitsigns: reset buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Gitsigns: undo stage hunk")

			-- Inspect.
			map("n", "<leader>hp", gs.preview_hunk, "Gitsigns: preview hunk")
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Gitsigns: blame line (full)")
			map("n", "<leader>hd", gs.diffthis, "Gitsigns: diff against index")

			-- Text object for a hunk (e.g. `vih`, `dih`).
			map({ "o", "x" }, "ih", gs.select_hunk, "Gitsigns: select hunk")
		end,
	},
}
