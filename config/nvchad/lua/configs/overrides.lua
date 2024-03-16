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
		"ruff",
		"pyright",

		-- shell stuff
		"shfmt",
		"shellcheck",

		-- docs
		"marksman",
		"taplo",

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
	},
}

return M
