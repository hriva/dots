require("nvchad.mappings")
local map = vim.keymap.set

-- Pasting
map("n", "cv", '"0p', { desc = "Paste Clipboard", noremap = true })

-- Spelling
map("n", "<leader>ss", ":setlocal spell spelllang=es<cr>", { desc = "Spelling es", noremap = true })
map("n", "<leader>se", ":setlocal spell spelllang=en_us<cr>", { desc = "Spelling en", noremap = true })
map("n", "<leader>sd", ":setlocal nospell<cr>", { desc = "Spelling Disable", noremap = true })

-- Gitsigns
map("n", "<leader>do", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff Open" })
map("n", "wq", "<cmd>wincmd p | q<cr>", { desc = "Window QuitPrevious" })

-- Keymaps
map("n", "<leader>wm", "<cmd>Telescope keymaps<cr>", { desc = "Wich Keymap" })

-- Conform
local conform = require("conform")

map("n", "<leader>cf", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Disable mappings
local nomap = vim.keymap.del

nomap("n", "<leader>e")

-- IN NORMAL MODE
-- <S-p> paste before Cursor
-- w word ahead
-- e word ahead
-- b word back

-- ProjectMgr
-- map("n", "<leader>fp", ":ProjectMgr<cr>", { desc = "Open Projects" })

-- Dap
-- map("n", "<leader>db", function()
-- 	require("dap-python").debug_selection()
-- end, { desc = "DapToggleBreakpoint" })
--
-- map("n", "<leader>dpr", function()
-- 	require("dap-python").debug_selection()
-- end, { desc = "DapDebugSelection" })
