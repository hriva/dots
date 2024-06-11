require("nvchad.mappings")
local map = vim.keymap.set

-- QOL
map("n", "<C-s>", "<cmd>silent write<cr>", { desc = "File Save", noremap = true })
map("v", "J", ":m '>+1<CR>gv-gv", { desc = "Move Selection Down" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "Move Selection Up" })
map("n", "J", "mzJ`z", { desc = "Append In Place" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page Half Down Centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page Half Up Centered" })
map("n", "n", "nzzzv", { desc = "Next Search and Center" })
map("n", "N", "Nzzzv", { desc = "Prev Search and Center" })
map("n", "Q", "<nop>")
map("n", "x", '"_x', { noremap = true, silent = true })
map("v", "x", '"_x', { noremap = true, silent = true })

-- Pasting
map("n", "cv", '"0p', { desc = "Paste Last Yank", noremap = true })

-- Spelling
map("n", "<leader>ss", ":setlocal spell spelllang=es<cr>", { desc = "Spelling es", noremap = true })
map("n", "<leader>se", ":setlocal spell spelllang=en_us<cr>", { desc = "Spelling en", noremap = true })
map("n", "<leader>sd", ":setlocal nospell<cr>", { desc = "Spelling Disable", noremap = true })

-- Multipane sizing
map("n", "<A-k>", "<cmd>vertical resize +2<cr>", { desc = "Spelling Disable", noremap = true })
map("n", "<A-j>", "<cmd>vertical resize -2<cr>", { desc = "Spelling Disable", noremap = true })
map("n", "<A-K>", "<cmd>horizontal resize +2<cr>", { desc = "Spelling Disable", noremap = true })
map("n", "<A-J>", "<cmd>horizontal resize -2<cr>", { desc = "Spelling Disable", noremap = true })

-- Gitsigns
map("n", "<leader>do", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff Open" })
map("n", "wq", "<cmd>wincmd p | q<cr>", { desc = "Window Quit Previous" })

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
