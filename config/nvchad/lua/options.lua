require("nvchad.options")

-- vscode format i.e json files
vim.g.vscode_snippets_path = vim.fn.expand("~/.config/code-snippets")

-- add yours here!
local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Auto hide status line
opt.cmdheight = 0
opt.diffopt:append({ "algorithm:patience" })

autocmd("CmdlineEnter", {
	group = augroup("cmdheight_1_on_cmdlineenter", { clear = true }),
	desc = "Don't hide the status line when typing a command",
	command = ":set cmdheight=1",
})

autocmd({ "CmdlineLeave", "InsertEnter" }, {
	group = augroup("cmdheight_0_on_cmdlineleave", { clear = true }),
	desc = "Hide cmdline when not typing a command",
	command = ":set cmdheight=0",
})

autocmd("BufWritePost", {
	group = augroup("hide_message_after_write", { clear = true }),
	desc = "Get rid of message after writing a file",
	pattern = { "*" },
	command = "redrawstatus",
})

-- autocmd("FileType", {
-- 	pattern = "python", -- filetype for which to run the autocmd
-- 	callback = function()
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true
-- 	end,
-- })

autocmd("BufWinEnter", {
	desc = "Clear the last used search pattern",
	pattern = "*",
	command = "let @/ = ''",
})
