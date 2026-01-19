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
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = vim.split(logo, "\n"),
				hide = {
					statusline = false,
				},
				center = {
					{
						icon = " ",
						icon = " ",
						desc = "Find File",
						key = "f",
						keymap = "Spc f",
						action = "Telescope find_files",
					},
					{
						icon = " ",
						desc = "Recent Projects",
						key = "p",
						keymap = "Spc f",
						action = "Telescope projects",
					},
					{
						icon = " ",
						desc = "Recent File",
						key = "o",
						keymap = "Spc f",
						action = "Telescope oldfiles",
					},
					{
						icon = "  ",
						desc = "Open Folder",
						key = "O",
						keymap = "Spc f",
						action = "Telescope file_browser",
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
		})
	end,
}
