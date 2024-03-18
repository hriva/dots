require("nvchad.options")

-- add yours here!
local autocmd = vim.api.nvim_create_autocmd
local opt = vim.opt

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

autocmd("FileType", {
	pattern = "python", -- filetype for which to run the autocmd
	callback = function()
		opt.expandtab = true
		opt.shiftwidth = 4
		opt.tabstop = 4
		opt.softtabstop = 4
		opt.smartindent = true
		opt.foldmethod = "indent"
	end,
})

-- settings for Markdown
autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		opt.wrap = true
		opt.shiftwidth = 4
		opt.expandtab = true
		opt.autoindent = true
		opt.smartindent = true
	end,
})

autocmd("FileType", {
	pattern = "r", -- filetype for which to run the autocmd
	callback = function()
		opt.expandtab = true
		opt.shiftwidth = 2
		opt.tabstop = 2
		opt.softtabstop = 2
		opt.smartindent = true
		opt.foldmethod = "indent"
	end,
})
