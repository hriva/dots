local iron = require("iron.core")
local iron_ft = require("iron.fts")

iron_ft.python.python.block_deviders = { "# %%", "#%%" }

local opts = {
	config = {
		scratch_repl = true, -- Whether a repl should be discarded or not
		repl_definition = {
			python = iron_ft.python.python,
			r = iron_ft.r.R,
			rmd = iron_ft.r.R,
		},
		repl_open_cmd = require("iron.view").split("35%"),
	},
	should_map_plug = true,
	keymaps = {
		toggle_repl = "<space>rs",
		visual_send = "<leader>rc",
		send_file = "<leader>rf",
		send_line = "<leader>rl",
		send_until_cursor = "<leader>ru",
		send_code_block = "<leader>rb",
		interrupt = "<leader>ri",
		exit = "<leader>rq",
		clear = "<leader>rr",
	},
	highlight = {},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

iron.setup(opts)
