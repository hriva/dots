local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
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
		"black",
		"ruff",
		"basedpyright",

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

return M
