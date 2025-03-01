require("nvchad.options")
local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- vscode format i.e json files
vim.g.vscode_snippets_path = vim.fn.expand("~/.config/code-snippets")
opt.autoread = true -- sync buffers automatically
opt.swapfile = false -- disable swapfile and showing the error
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.cmdheight = 0
opt.diffopt:append({ "algorithm:patience" })
opt.diffopt:prepend({ "vertical" })
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldnestmax = 9
opt.foldcolumn = "0"

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

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

autocmd("BufWinEnter", {
	desc = "Clear the last used search pattern and exit search highlight",
	pattern = "*",
	command = "let @/ = '' | nohlsearch",
})

-- Autocmd to close NvimTree buffer before exiting Neovim
autocmd("VimLeavePre", {
	pattern = "*",
	callback = function()
		if vim.fn.exists(":NvimTreeClose") == 2 then
			vim.cmd("NvimTreeClose")
		end
	end,
})
