return {
	signs = {
		delete = { text = "󰍵" },
		changedelete = { text = "󱕖" },
	},

	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Show
		map("n", "<leader>go", function()
			gitsigns.show(vim.fn.input("Commit or Reference: "))
		end, { desc = "git show revision" })

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "git next change" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "git previous change" })

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git stage hunk" })
		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git reset hunk" })

		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git stage selection" })

		map("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git reset selection" })

		map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git stage file" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git reset file" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git preview hunk" })
		map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "git preview hunk inline" })

		map("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "git blame line" })

		map("n", "<leader>gd", gitsigns.diffthis, { desc = "git diff" })

		map("n", "<leader>gD", function()
			local reference = vim.fn.input("Commit or Reference: ")
			gitsigns.diffthis(reference or "~")
		end, { desc = "git diff HEAD" })

		-- Toggles
		map("n", "<leader>gl", function()
			gitsigns.setqflist("all")
		end, { desc = "git quickfix list" })
		map("n", "<leader>gx", gitsigns.toggle_deleted, { desc = "git toggle deleted" })
		map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "git toggle word diff" })

		-- Text object
		map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", { desc = "inside hunk" })
	end,
}
