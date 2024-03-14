local M = {}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
	},
}

M.dap_python = {
	plugin = true,
	v = {
		["<leader>dpr"] = {
			function()
				require("dap-python").debug_selection()
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

M.projects = {
	n = {
		["<leader>fp"] = { "<cmd> ProjectMgr<CR>", "Open Projects" },
	},
}

M.iron = {
	-- plugin = true,
	v = {
		["<leader>rc"] = {
			function()
				require("iron").core.visual_send()
			end,
			"Send to REPL",
		},
	},
	n = {
		["<leader>rf"] = {
			function()
				require("iron").core.send_file()
			end,
			"Run File",
		},
		["<leader>ru"] = {
			function()
				require("iron").core.send_until_cursor()
			end,
			"Run Until Cursor",
		},
		["<leader>rl"] = {
			function()
				require("iron").core.send_line()
			end,
			"Run Line",
		},
		["<leader>rs"] = {
			function()
				require("iron").core.close_repl(ft)
			end,
			"Stop REPL",
		},
	},
}

return M
