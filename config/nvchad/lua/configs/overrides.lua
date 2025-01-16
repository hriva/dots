local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"vimdoc",
		"lua",
		"bash",
		"python",
		"json",
		"r",
		"toml",
		"markdown",
		"markdown_inline",
		"luadoc",
		"printf",
	},
	indent = {
		enable = true,
		disable = {
			"python",
		},
	},
	highlight = {
		enable = true,
		use_languagetree = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]C"] = "@class.outer",
				["]A"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[C"] = "@class.outer",
				["[A"] = "@parameter.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},
	view = {
		width = 25,
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = false,
			},
		},
	},
	filters = {
		enable = false,
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		ignore_dirs = {
			"/.ccls-cache",
			"/build",
			"/node_modules",
			"/target",
			"/__pycache__",
			"/develop-eggs",
			"/dist",
			"/eggs",
		},
	},
}

M.better_escape = {
	timeout = 150,
	default_mappings = false,
	mappings = {
		i = {
			j = {
				-- These can all also be functions
				k = "<Esc>",
				j = "<Esc>",
			},
		},
		c = {},
		t = {
			j = {
				k = "<Esc>",
				j = "<Esc>",
			},
		},
		s = {},
		v = {
			j = {
				k = "<Esc>",
			},
		},
	},
}

M.bigfile = {
	filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
	pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
	features = { -- features to disable
		"indent_blankline",
		"illuminate",
		"lsp",
		"treesitter",
		"syntax",
		"matchparen",
		-- "vimopts",
		"filetype",
	},
}

return M
