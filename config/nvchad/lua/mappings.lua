require("nvchad.mappings")
local map = vim.keymap.set

-- Conform
local conform = require("conform")

map("n", "<leader>cf", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- ProjectMgr
map("n", "<leader>fp", ":ProjectMgr<cr>", { desc = "Open Projects" })

-- Disable mappings
local nomap = vim.keymap.del

nomap("n", "<leader>e")

-- Dap
-- map("n", "<leader>db", function()
-- 	require("dap-python").debug_selection()
-- end, { desc = "DapToggleBreakpoint" })
--
-- map("n", "<leader>dpr", function()
-- 	require("dap-python").debug_selection()
-- end, { desc = "DapDebugSelection" })

-- -- Iron
-- local iron = require("iron")

-- map("v", "<leader>rc", function()
-- 	iron.core.visual_send()
-- end, { desc = "Run Chunck" })
--
-- map("n", "<leader>rf", function()
-- 	iron.core.send_file()
-- end, { desc = "Run File" })
--
-- map("n", "<leader>ru", function()
-- 	iron.core.send_until_cursor()
-- end, { desc = "Run Until Cursor" })
--
-- map("n", "<leader>rl", function()
-- 	iron.core.send_line()
-- end, { desc = "Run Line" })
--
-- map("n", "<leader>rs", function()
-- 	iron.core.close_repl(ft)
-- end, { desc = "Run Close" })
