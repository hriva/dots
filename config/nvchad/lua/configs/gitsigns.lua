return {
	signs = {
		delete = { text = "󰍵" },
		changedelete = { text = "󱕖" },
	},

	on_attach = function(bufnr)
		local gs = require("gitsigns")

		local function opts(desc)
			return { buffer = bufnr, desc = desc }
		end

		local map = vim.keymap.set

		map("n", "<leader>rh", gs.reset_hunk, opts("reset hunk"))
		map("n", "<leader>ph", gs.preview_hunk, opts("preview hunk"))
		map("n", "<leader>gb", gs.blame_line, opts("blame line"))
		map("n", "]h", function()
			gs.nav_hunk("next")
		end, { desc = "go to next hunk", noremap = true, silent = true })
		map("n", "[h", function()
			gs.nav_hunk("prev")
		end, { desc = "go to previous hunk", noremap = true, silent = true })
		map("n", "<leader>do", gs.diffthis, { desc = "diff open" })
		map("n", "<leader>dO", function()
			gs.diffthis("~")
		end, { desc = "diff last change" })
	end,
}
