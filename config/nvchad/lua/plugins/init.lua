local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

local overrides = require("configs.overrides")

return {
	{
		-- nvchad plugin override
		"stevearc/conform.nvim",
		-- enabled = false,
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		config = function()
			require("configs.conform")
		end,
	},
	{
		"folke/which-key.nvim",
		lazy = false,
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

	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	enabled = false,
	-- },

	-- end

	-- text editing
	{
		"LunarVim/bigfile.nvim",
		lazy = false,
		event = { "FileReadPre", "BufReadPre" },
		opts = overrides.bigfile,
	},
	{
		"max397574/better-escape.nvim",
		event = { "LazyFile" },
		opts = overrides.better_escape,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"nvim-mini/mini.ai",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		config = function(_, opts)
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.surround",
		event = { "BufReadPost", "BufNewFile" },
		version = false,
		config = function(_, opts)
			require("mini.surround").setup()
		end,
	},
	-- word
	{
		"saghen/blink.cmp",
		enabled = false,
		version = "*",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			-- {
			-- 	"hrsh7th/nvim-cmp",
			-- 	enabled = false,
			-- },
		},
		opts = require("configs.blink"),
		opts_extend = { "sources.default" },
	},

	-- coding
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{ "microsoft/python-type-stubs" },
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
		"hedyhli/outline.nvim",
		keys = { { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" } },
		config = function()
			require("outline").setup({})
		end,
	},
	{
		"creativenull/efmls-configs-nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		enabled = false,
	},
	{
		"Vigemus/iron.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = { "python", "r", "rmd" },
		config = function()
			require("configs.iron")
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

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
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
}
