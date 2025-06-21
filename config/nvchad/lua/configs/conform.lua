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

conform.formatters.tergo = {
	meta = {
		url = "https://github.com/kpagacz/tergo",
		description = "Tergo R formatter",
	},
	command = "/usr/bin/R",
	-- Any args to style_file must be passed after `commandArgs(TRUE)`
	args = { "-e", "tergo::style_file(commandArgs(TRUE))", "--args", "$FILENAME" },
	-- "--no-init-file" before "e" to ignore .Rprofile, for example
	-- to avoid long renv startup time
	prepend_args = { "-s", "--no-init-file" },
	stdin = false,
}

local options = {
	log_level = vim.log.levels.ERROR, -- Use `:ConformInfo` to see the location of the log file.
	notify_on_error = true,

	default_format_opts = {
		lsp_format = "fallback",
		async = true,
	},

	format_on_save = {
		timeout_ms = 500, -- While enabling async in lspfallback
	},

	format_after_save = {
		timeout_ms = 10000, -- While enabling async in lspfallback
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
		-- r = { "air" },
		-- rmd = { "air" },

		-- Fallback formatter. Overrides Lsp fallback
		["_"] = { "trim_whitespace", lsp_format = "last" },
		-- Use the "*" filetype to run formatters on all filetypes.
		["*"] = { "trim_newlines" },
	},
}

conform.setup(options)
