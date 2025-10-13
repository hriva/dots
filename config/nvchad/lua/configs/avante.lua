-- views can onlyj be fully collapsed with the global statusline
vim.opt.laststatus = 3
local Utils = require("avante.utils")

return {
	instructions_file = "AGENTS.md",
	mode = "agentic",
	memory_summary_provider = nil,
	rules = {
		project_dir = ".context/rules", -- relative to project root, can also be an absolute path
		global_dir = "~/.config/avante/rules", -- absolute path
	},
	provider = "ollama",
	providers = {
		ollama = {
			endpoint = os.getenv("OLLAMA_REMOTE") or "http://127.0.0.1:11434", -- /v1 at the end.
			model = os.getenv("AVANTE_MODEL"),
			model_names = {
				"cogito:8b",
			},
			extra_request_body = {
				options = {
					temperature = os.getenv("AVANTE_MODEL_TEMPERATURE") or 0.75,
					num_ctx = os.getenv("AVANTE_MODEL_CONTEXT") or 32768,
				},
			},
		},
	},

	auto_suggestions_provider = nil, -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
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
		use_cwd_as_project_root = false,
		auto_focus_on_diff_view = false,
		auto_approve_tool_permissions = true, -- Default: auto-approve all tools (no prompts)
		auto_check_diagnostics = true,
		enable_fastapply = false,
		include_generated_by_commit_line = false, -- Controls if 'Generated-by: <provider/model>' line is added to git commit message
		auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat
	},
	prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
		enabled = true, -- toggle logging entirely
		log_dir = vim.fn.stdpath("cache"), -- directory where logs are saved
		max_entries = 100, -- the uplimit of entries that can be sotred
		next_prompt = {
			normal = "<C-n>", -- load the next (newer) prompt log in normal mode
			insert = "<C-n>",
		},
		prev_prompt = {
			normal = "<C-p>", -- load the previous (older) prompt log in normal mode
			insert = "<C-p>",
		},
	},
	history = {
		max_tokens = 8192,
		storage_path = Utils.join_paths(vim.fn.stdpath("state"), "avante"),
		paste = {
			extension = "png",
			filename = "pasted-%Y%m%dT%H%M.%S",
		},
	},
	highlights = {
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	img_paste = {
		url_encode_path = true,
		template = "\nimage: $FILE_PATH\n",
	},
	mappings = {
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
		cancel = {
			normal = { "<C-c>", "<Esc>", "q" },
			insert = { "<C-c>" },
		},
		ask = "<leader>aa",
		new_ask = "<leader>an",
		zen_mode = "<leader>az",
		edit = "<leader>ae",
		refresh = "<leader>ar",
		focus = "<leader>af",
		stop = "<leader>aS",
		toggle = {
			default = "<leader>at",
			debug = "<leader>ad",
			selection = "<leader>aC",
			suggestion = "<leader>as",
			repomap = "<leader>aR",
		},
		sidebar = {
			expand_tool_use = "<S-Tab>",
			next_prompt = "]p",
			prev_prompt = "[p",
			apply_all = "A",
			apply_cursor = "a",
			retry_user_request = "r",
			edit_user_request = "e",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
			toggle_code_window = "x",
			remove_file = "d",
			add_file = "@",
			close = { "q" },
			close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
			toggle_code_window_from_input = nil, -- e.g., { normal = "x", insert = "<C-;>" }
		},
		files = {
			add_current = "<leader>ac", -- Add current buffer to selected files
			add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
		},
		select_model = "<leader>a?", -- Select model command
		select_history = "<leader>ah", -- Select history command
		confirm = {
			focus_window = "<C-w>f",
			code = "c",
			resp = "r",
			input = "i",
		},
	},
	windows = {
		---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
		position = "right",
		fillchars = "eob: ",
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
			-- border = "rounded",
			border = { " ", " ", " ", " ", " ", " ", " ", " " },
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			-- border = "rounded",
			border = { " ", " ", " ", " ", " ", " ", " ", " " },
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
	--- Allows selecting code or other data in a buffer and ask LLM questions about it or
	--- to perform edits/transformations.
	--- @class AvanteSelectionConfig
	--- @field enabled boolean
	--- @field hint_display "delayed" | "immediate" | "none" When to show key map hints.
	selection = {
		enabled = true,
		hint_display = "none",
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
		negate_patterns = { "%.context" }, -- negate ignore files matching these.
	},
	selector = {
		---@alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | nil
		---@type avante.SelectorProvider
		provider = "telescope",
		provider_opts = {},
		exclude_auto_select = {}, -- List of items to exclude from auto selection
	},
	suggestion = {
		debounce = 600,
		throttle = 600,
	},
	disabled_tools = {}, ---@type string[]
	custom_tools = {},
	slash_commands = {},
	shortcuts = {},
	ask_opts = {},
}
