local lint = require("lint")

local pattern = "([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*)"
local groups = { "file", "lnum", "col", "end_lnum", "end_col", "severity", "message" }
local severities = {
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
	note = vim.diagnostic.severity.HINT,
}

lint.linters_by_ft = {
	sh = { "shellcheck" },
	-- python = { "ruff" },
	-- markdown = { "vale" },
	zsh = { "zsh" },
	json = { "biomejs" },
	jsonc = { "biomejs" },
	make = { "checkmake" },

	-- Use the "*" filetype to run linters on all filetypes.
	-- ['*'] = { 'global linter' },
	-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
	-- ['_'] = { 'fallback linter' },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufWritePost",
	"BufReadPost",
	"InsertLeave", -- for stdin linters
}, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
