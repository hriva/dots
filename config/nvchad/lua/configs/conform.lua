--type conform.options
local conform = require("conform")

conform.formatters.biome = {
	args = {
		"format",
		"--config-path",
		os.getenv("BIOME_CONFIG_PATH"),
		"--stdin-file-path",
		"$FILENAME",
		"--json-formatter-indent-style=space",
	},
}
conform.formatters.prettyr = {
	inherit = false,
	stdin = false,
	command = "prettyr",
	args = { "$FILENAME" },
}

local options = {
	log_level = vim.log.levels.ERROR, -- Use `:ConformInfo` to see the location of the log file.
	notify_on_error = true,
	lsp_format = "fallback",

	default_format_opts = {
		lsp_format = "fallback",
		async = true,
	},

	format_on_save = {
		timeout_ms = 500, -- While enabling async in lspfallback
		lsp_format = "fallback",
	},
	format_after_save = {
		timeout_ms = 10000, -- While enabling async in lspfallback
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt", "shellharden" },
		toml = { "taplo" },
		python = { "ruff_format" },
		json = { "jq" },
		jsonc = { "biome" },
		xml = { "xmllint" },
		yaml = { "yq" },
		markdown = { "trim_newlines" },
		-- r = { "prettyr" },
		-- rmd = { "prettyr" },

		-- Fallback formatter.
		["_"] = { "trim_whitespace" },
		-- Use the "*" filetype to run formatters on all filetypes.
		["*"] = { "trim_newlines" },
	},
}

conform.setup(options)
