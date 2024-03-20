-- Register linters and formatters per language
-- local shellcheck = require("efmls-configs.linters.shellcheck")
-- local vale = require("efmls-configs.linters.vale")
-- local mypy = require("efmls-configs.linters.mypy")
local languages = {
	-- sh = { shellcheck },
	-- python = { mypy },
	-- markdown = { vale },
}

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	},
}

return efmls_config
