local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {

	-- b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

	-- cpp
	b.diagnostics.mypy,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
