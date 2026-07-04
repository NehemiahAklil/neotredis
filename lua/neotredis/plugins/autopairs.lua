return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%)%>%]%)%}%,]]=],
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
	},
}
