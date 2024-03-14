-- Register linters and formatters per language
local shellcheck = require("efmls-configs.linters.shellcheck")
-- local mypy = require("efmls-configs.linters.mypy")
local languages = {
	sh = { shellcheck },
	-- python = { mypy },
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
	},
}

return efmls_config
