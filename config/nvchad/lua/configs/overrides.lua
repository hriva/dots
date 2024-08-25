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
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- python
		"ruff",
		"basedpyright",
		"debugpy",

		-- shell stuff
		"shfmt",
		"shellcheck",

		-- docs
		"marksman",
		"taplo",
		"vale",

		-- none-ls substitue
		"efm",
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
}

M.better_escape = {
	timeout = vim.o.timeoutlen,
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
		v = {},
		s = {},
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
