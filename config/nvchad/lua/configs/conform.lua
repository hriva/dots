--type conform.options
local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },

		sh = { "shfmt", "shellharden" },

		toml = { "taplo" },

		python = { "black", "ruff_format" },

		json = { "jq" },

		jsonc = { "biome" },

		-- r = { "styler", },
		-- have other formatters configured.
		["_"] = { "trim_whitespace" },
	},

	-- adding same formatter for multiple filetypes can look too much work for some
	-- instead of the above code you could just use a loop! the config is just a table after all!

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 1000,
		lsp_fallback = true,
	},
	-- Use `:ConformInfo` to see the location of the log file.
	log_level = vim.log.levels.ERROR,
	notify_on_error = true,
}

require("conform").setup(options)
