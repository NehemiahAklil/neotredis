return {
	"nvim-mini/mini.ai",
	version = false,
	event = "VeryLazy",
	opts = {
		-- Search up to this many lines for a text object before giving up.
		n_lines = 500,
		-- Defaults already provide the motions the plan wants, all without
		-- treesitter-textobjects (this repo uses the arborist wrapper):
		--   f — function CALL   → `daf` deletes `foo(bar)`
		--   a — argument        → `cia` changes inside an argument
		--   ) ] } ` " '         → balanced brackets / quotes
		--   t — HTML/XML tag
		--   ? — user-prompted region
	},
}
