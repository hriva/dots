local iron = require("iron.core")

iron.setup({
	config = {
		scratch_repl = true, -- Whether a repl should be discarded or not
		repl_definition = {
			sh = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "bash" },
			},
			python = require("iron.fts.python").ipython,
		},
		repl_open_cmd = require("iron.view").split("35%"),
	},
	should_map_plug = true,
	keymaps = {
		-- cr = "<leader>s<cr>",
		interrupt = "<leader>sr",
		exit = "<leader>sq",
		-- clear = "<leader>cl",
	},
	-- If the highlight is on, you can change how it looks, check nvim_set_hl
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})
