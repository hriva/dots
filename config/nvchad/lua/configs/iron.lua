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
			r = require("iron.fts.r").R,
			rmd = require("iron.fts.r").R,
		},
		repl_open_cmd = require("iron.view").split("35%"),
	},
	should_map_plug = true,
	keymaps = {
		visual_send = "<leader>rc",
		send_file = "<leader>rf",
		send_line = "<leader>rl",
		send_until_cursor = "<leader>ru",
		-- cr = "<leader>s<cr>",
		interrupt = "<leader>ri",
		exit = "<leader>rq",
		-- clear = "<leader>cl",
	},
	-- -- If the highlight is on, you can change how it looks, check nvim_set_hl
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})

-- local map = vim.keymap.set
-- -- Iron
-- map("v", "<leader>rc", function()
-- 	iron.visual_send()
-- end, { desc = "Run Chunck" })
--
-- map("n", "<leader>rf", function()
-- 	iron.send_file()
-- end, { desc = "Run File" })
--
-- map("n", "<leader>ru", function()
-- 	iron.send_until_cursor()
-- end, { desc = "Run Until Cursor" })
--
-- map("n", "<leader>rl", function()
-- 	iron.send_line()
-- end, { desc = "Run Line" })
--
-- map("n", "<leader>rs", function()
-- 	iron.close_repl(ft)
-- end, { desc = "Run Close" })
