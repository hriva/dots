local M = {}

M = {
	fuzzy = { prebuilt_binaries = { force_version = nil } },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	appearance = {
		use_nvim_cmp_as_default = true, -- fallback hl groups eq nvim-cmp's hl groups
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	keymap = {
		preset = "none",
		["<C-y>"] = {},
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-d>"] = { "show_documentation", "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "show_documentation", "scroll_documentation_up", "fallback" },
		["<C-Space>"] = {
			function(cmp)
				cmp.show()
			end,
			"fallback",
		},
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept" },
		["<C-b>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},

	completion = {
		trigger = { prefetch_on_insert = false },
		accept = { auto_brackets = { enabled = false } },
		menu = { border = "single", auto_show = true },
		documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "single" } },
		-- list = { selection = "auto_insert" }df,
		--
	},
	signature = { window = { border = "single" } },
}

return M
