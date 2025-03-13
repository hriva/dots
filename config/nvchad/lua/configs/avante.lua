-- views can onlyj be fully collapsed with the global statusline
vim.opt.laststatus = 3
require("avante_lib").load()
require("avante").setup({
	provider = "ollama",
	ollama = {
		endpoint = os.getenv("OLLAMA_REMOTE"), -- /v1 at the end.
		model = os.getenv("AVANTE_MODEL"),
	},
	auto_suggestions_provider = "ollama", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
	behaviour = {
		enable_cursor_planning_mode = true, -- enable cursor planning mode!
		auto_focus_sidebar = true,
		auto_suggestions = false, -- Experimental stage
		auto_suggestions_respect_ignore = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		jump_result_buffer_on_finish = false,
		support_paste_from_clipboard = false,
		minimize_diff = true,
		enable_token_counting = true,
	},
	history = {
		max_tokens = 8192,
		storage_path = vim.fn.stdpath("state") .. "/avante",
		paste = {
			extension = "png",
			filename = "pasted-%Y%m%dT%H%M.%S",
		},
	},
	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	windows = {
		---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
		position = "right",
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width in vertical layout
		height = 30, -- default % based on available height in horizontal layout
		sidebar_header = {
			enabled = true, -- true, false to enable/disable the header
			align = "center", -- left, center, right for title
			rounded = true,
		},
		input = {
			prefix = "> ",
			height = 8, -- Height of the input window in vertical layout
		},
		edit = {
			border = "rounded",
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			border = "rounded",
			start_insert = true, -- Start insert mode when opening the ask window
			---@alias AvanteInitialDiff "ours" | "theirs"
			focus_on_apply = "ours", -- which diff to focus after applying
		},
	},
	--- @class AvanteConflictConfig
	diff = {
		autojump = true,
		--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
		--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
		--- Disable by setting to -1.
		override_timeoutlen = 500,
	},
	--- @class AvanteHintsConfig
	hints = {
		enabled = false,
	},
	--- @class AvanteRepoMapConfig
	repo_map = {
		ignore_patterns = {
			"%.git",
			"%.worktree",
			"__pycache__",
			"node_modules",
			"%.OLD",
			"%.bak",
			"%.env",
			"%.csv",
			"%.envrc",
			"Session.nvim",
			"LICENSE",
			"LICENSE.txt",
		}, -- ignore files matching these
		negate_patterns = {}, -- negate ignore files matching these.
	},
	--- @class AvanteFileSelectorConfig
	file_selector = {
		--- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
		provider = "native",
		-- Options override for custom providers
		provider_opts = {},
		--- @type fun(selected_paths: string[] | string | nil): nil
		handler = nil,
	},
	suggestion = {
		debounce = 600,
		throttle = 600,
	},
})
