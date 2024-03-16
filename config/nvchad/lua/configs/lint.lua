local lint = require("lint")

local pattern = "([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*)"
local groups = { "file", "lnum", "col", "end_lnum", "end_col", "severity", "message" }
local severities = {
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
	note = vim.diagnostic.severity.HINT,
}

require("lint").linters.mypy_venv = {
	cmd = os.getenv("VIRTUAL_ENV") .. "/bin/mypy",
	stdin = false,
	append_fname = true,
	ignore_exitcode = false,
	args = {
		"--show-column-numbers",
		"--show-error-end",
		"--hide-error-codes",
		"--hide-error-context",
		"--no-color-output",
		"--no-error-summary",
		"--no-pretty",
		"--follow-imports",
	},
	parser = require("lint.parser").from_pattern(pattern, groups, severities, { ["source"] = "mypy_venv" }),
}

lint.linters_by_ft = {
	sh = { "shellcheck" },
	python = { "mypy_venv" },
	-- Use the "*" filetype to run linters on all filetypes.
	-- ['*'] = { 'global linter' },
	-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
	-- ['_'] = { 'fallback linter' },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
