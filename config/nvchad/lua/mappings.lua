require("nvchad.mappings")
local map = vim.keymap.set

-- Spelling
map("n", "<leader>ss", ":setlocal spell spelllang=es<cr>", { desc = "Spelling es" })
map("n", "<leader>se", ":setlocal spell spelllang=en_us<cr>", { desc = "Spelling en" })
map("n", "<leader>sd", ":setlocal nospell<cr>", { desc = "Spelling Disable" })

-- Gitsigns
map("n", "<leader>do", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff Open" })
map("n", "<leader>wq", "<cmd>wincmd p | q<cr>", { desc = "Window QuitPrevious" })

-- Keymaps
map("n", "<leader>wm", "<cmd>Telescope keymaps<cr>", { desc = "Wich Keymap" })

-- Conform
local conform = require("conform")

map("n", "<leader>cf", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- ProjectMgr
-- map("n", "<leader>fp", ":ProjectMgr<cr>", { desc = "Open Projects" })

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
