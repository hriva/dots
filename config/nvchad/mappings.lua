local M = {}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
	},
}

M.dap_python = {
	plugin = true,
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
		},
	},
}

M.conform = {
	plugin = true,
	n = {
		["<leader>cf"] = {
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
}

return M
