local overrides = require("configs.overrides")

return {
	{
		-- Override plugin definition options
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		config = function()
			require("configs.conform")
		end,
	},
	-- override plugin configs
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = overrides.treesitter,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
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
		event = { "InsertEnter" },
		opts = overrides.better_escape,
		config = function(_, opts)
			require("better_escape").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
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
		"rcarriga/nvim-dap-ui",
		dependencies = "mfussenegger/nvim-dap",
		enabled = false,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		enabled = false,
		config = function(_, opts)
			require("core.utils").load_mappings("dap")
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		enabled = false,
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			local path = "~/Code/.devel-env/bin/ipython"
			require("dap-python").setup(path)
			require("core.utils").load_mappings("dap_python")
		end,
	},
}
