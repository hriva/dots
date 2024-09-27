require("avante_lib").load()
require("avante").setup({
	provider = "ollama",
	vendors = {
		---@type AvanteProvider
		ollama = {
			["local"] = true,
			endpoint = os.getenv("OLLAMA_REMOTE") .. "/v1",
			model = "qwen2.5-coder:latest",
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
						max_tokens = 2048,
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
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
		},
	},
	hints = { enabled = true },
	windows = {
		---@type "right" | "left" | "top" | "bottom"
		position = "right", -- the position of the sidebar
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width
		sidebar_header = {
			align = "center", -- left, center, right for title
			rounded = true,
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
