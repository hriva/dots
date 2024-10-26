local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

local overrides = require("configs.overrides")

return {
	{
		-- nvchad plugin override
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		config = function()
			require("configs.conform")
		end,
	},
	{
		"folke/which-key.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		keys = { "<space>", "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "V", "v", "g" },
		cmd = "WhichKey",
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		init = function(plugin)
			-- PERF: add to rtp and query predicates early
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		opts = overrides.treesitter,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = function()
			return require("configs.gitsigns")
		end,
	},
	{
		"williamboman/mason.nvim",
	},
	-- Install a plugin
	{
		"LunarVim/bigfile.nvim",
		lazy = false,
		event = { "FileReadPre", "BufReadPre" },
		enabled = true,
		opts = overrides.bigfile,
		config = function(_, opts)
			require("bigfile").setup(opts)
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = { "LazyFile" },
		opts = overrides.better_escape,
		config = function(_, opts)
			require("better_escape").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		enabled = true,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave", "VeryLazy" },
		config = function()
			require("configs.lint")
		end,
	},
	{
		"creativenull/efmls-configs-nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		enabled = true,
	},
	{ "microsoft/python-type-stubs" },
	{
		"Vigemus/iron.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = { "python", "r", "rmd" },
		-- enabled = false,
		config = function()
			require("configs.iron")
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function(_, opts)
			require("configs.rainbow")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		enabled = true,
	},
	-- disabled
	{
		"charludo/projectmgr.nvim",
		lazy = false, -- important!
		enabled = false,
		config = function()
			require("projectmgr").setup({
				autogit = {
					enabled = true,
					command = "git pull --ff-only > .git/fastforward.log 2>&1",
				},
				session = { enabled = true, file = "Session.vim" },
				shada = { enabled = false, file = "main.shada" },
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "mfussenegger/nvim-dap-python" },
			{ "nvim-telescope/telescope-dap.nvim" },
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		},
		enabled = true,
		ft = { "python" },
		config = function(_, opts)
			require("configs.dap")
		end,
	},
}
