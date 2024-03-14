local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		priority = 200,
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	-- override plugin configs
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin

	{
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		config = function()
			require("custom.configs.conform")
		end,
	},
	{
		"creativenull/efmls-configs-nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		enabled = true,
	},
	{
		"Vigemus/iron.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		ft = "python",
		-- enabled = false,
		config = function()
			require("custom.configs.iron")
		end,
	},
	{
		"charludo/projectmgr.nvim",
		lazy = false, -- important!
		config = function()
			require("projectmgr").setup({
				autogit = {
					enabled = true,
					command = "git pull --ff-only > .git/fastforward.log 2>&1",
				},
				session = { enabled = true, file = "Session.vim" },
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
return plugins
