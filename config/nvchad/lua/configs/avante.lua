require("avante_lib").load()
require("avante").setup({
	provider = "ollama",
	vendors = {
		---@type AvanteProvider
		ollama = {
			["local"] = true,
			endpoint = os.getenv("OLLAMA_REMOTE") or "127.0.0.1:11434/v1",
			model = os.getenv("AVANTE_MODEL") or "qwen2.5-coder:1.5b",
			parse_curl_args = function(opts, code_opts)
				return {
					url = opts.endpoint .. "/chat/completions",
					headers = {
						["Accept"] = "application/json",
						["Content-Type"] = "application/json",
					},
					body = {
						model = opts.model,
						messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
						max_tokens = 8192,
						stream = true,
					},
				}
			end,
			parse_response_data = function(data_stream, event_state, opts)
				require("avante.providers").openai.parse_response(data_stream, event_state, opts)
			end,
		},
	},
	auto_suggestions_provider = "ollama", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
	claude = {
		endpoint = "https://api.anthropic.com",
		model = "claude-3-5-sonnet-20240620",
		temperature = 0,
		max_tokens = 4096,
	},
	behaviour = {
		auto_suggestions = false, -- Experimental stage
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
	},
	mappings = {
		--- @class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		sidebar = {
			apply_all = "<M-A>",
			apply_cursor = "<M-a>",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
		},
	},
	hints = { enabled = false },
	windows = {
		---@type "right" | "left" | "top" | "bottom"
		position = "right", -- the position of the sidebar
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width
		sidebar_header = {
			enabled = true, -- true, false to enable/disable the header
			align = "center", -- left, center, right for title
			rounded = true,
		},
		input = {
			prefix = "> ",
		},
		edit = {
			border = "rounded",
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			start_insert = true, -- Start insert mode when opening the ask window, only effective if floating = true.
			border = "rounded",
		},
	},
	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	--- @class AvanteConflictUserConfig
	diff = {
		autojump = true,
		---@type string | fun(): any
		list_opener = "copen",
	},
})
