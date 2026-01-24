return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	config = function()
		local dashboard_header = [[
           ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆
            ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦
                  ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄
                   ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄
                  ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀
           ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄
          ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄
         ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄
         ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄
              ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆
               ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃

        ]]
		local logo = [[
            ███╗   ██╗███████╗ ██████╗ ████████╗██████╗ ███████╗██████╗ ██╗███████╗
            ████╗  ██║██╔════╝██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝██╔══██╗██║██╔════╝
            ██╔██╗ ██║█████╗  ██║   ██║   ██║   ██████╔╝█████╗  ██║  ██║██║███████╗
            ██║╚██╗██║██╔══╝  ██║   ██║   ██║   ██╔══██╗██╔══╝  ██║  ██║██║╚════██║
            ██║ ╚████║███████╗╚██████╔╝   ██║   ██║  ██║███████╗██████╔╝██║███████║
            ╚═╝  ╚═══╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝╚══════╝
        ]]
		logo = string.rep("\n", 8) .. logo .. "\n\n"
		opts = {
			theme = "doom",
			config = {
				header = vim.split(logo, "\n"),
				hide = {
					statusline = false,
				},
				center = {
					{
						icon = " ",
						icon_hl = "Title",
						desc = "Recent File",
						desc_hl = "Number",
						key = "o",
						keymap = "Spc f",
						key_hl = "Number",
						key_format = " %s", -- remove default surrounding `[]`
						action = "Telescope oldfiles",
					},
					{
						icon = " ",
						icon_hl = "Title",
						desc = "Recent Projects          ",
						desc_hl = "Number",
						key = "p",
						keymap = "Spc f",
						key_hl = "Number",
						key_format = " %s", -- remove default surrounding `[]`
						action = "Telescope projects",
					},
					{
						icon = " ",
						icon_hl = "Title",
						desc = "Open Folder",
						desc_hl = "String",
						key = "O",
						keymap = "Spc f",
						key_hl = "String",
						key_format = " %s", -- remove default surrounding `[]`
						action = "Telescope file_browser",
					},
					{
						icon = " ",
						icon_hl = "Title",
						desc = "Find File",
						desc_hl = "String",
						key = "f",
						keymap = "SPC f",
						key_hl = "String",
						key_format = " %s", -- remove default surrounding `[]`
						action = "Telescope find_files",
					},
					-- {
					-- 	icon = "  ",
					-- 	desc = "Mappings",
					-- 	key = "h",
					-- 	keymap = "Spc c",
					-- 	cmd = "map",
					-- },
				},
				footer = {},
			},
		}

		-- for _, button in ipairs(opts.config.center) do
		-- 	button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
		-- 	button.key_format = "  %s"
		-- end
		require("dashboard").setup(opts)
	end,
}
