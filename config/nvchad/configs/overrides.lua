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
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- python
		"black",
		"debugpy",
		"mypy",
		"ruff-lsp",
		"pyright",

		-- shell stuff
		"shfmt",
		"shellcheck",

		-- docs
		"marksman",

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
				git = true,
			},
		},
	},
}

return M
