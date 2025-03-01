require("nvchad.mappings")
local map = vim.keymap.set

-- QOL
map("n", "<C-s>", "<cmd>silent write<cr>", { desc = "file save", noremap = true })
map("v", "J", ":m '>+1<CR>gv-gv", { desc = "move selection down" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "move selection up" })
map("n", "J", "mzJ`z", { desc = "append in place" })
map("n", "<C-d>", "<C-d>zz", { desc = "page half down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "page half up centered" })
map("n", "n", "nzzzv", { desc = "next search and center" })
map("n", "N", "Nzzzv", { desc = "prev search and center" })
map("n", "x", '"_x', { noremap = true, silent = true, desc = "cut witouth clipboard" })
map("v", "x", '"_x', { noremap = true, silent = true, desc = "cut witouth clipboard" })
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
map("n", "<Esc>", "<Esc>:noh<CR>") -- remove highligh after escaping search
map("n", "<leader>dt", ":windo diffthis<CR>", { desc = "diff this", silent = true })
map("n", "<C-q>", "<cmd>q<cr>", { desc = "quit", silent = true })
map("n", "<leader>mx", "<cmd>!chmod 770 %<cr>", { desc = "make user executable", silent = true })
map("n", "<leader>mr", "<cmd>!chmod 660 %<cr>", { desc = "make read/write", silent = true })
map("n", "<leader>q", "<cmd>bufdo bwipeout<cr>", { desc = "buffer quit all", silent = true })
map("n", "Q", "<nop>")

-- Pasting
map("n", ",", '"0p', { desc = "paste last yank", noremap = true })
map("v", ",", '"0p', { desc = "paste last yank", noremap = true })

-- Spelling
map("n", "<leader>ss", ":setlocal spell spelllang=es<cr>", { desc = "spelling es", noremap = true })
map("n", "<leader>se", ":setlocal spell spelllang=en_us<cr>", { desc = "spelling en", noremap = true })
map("n", "<leader>sd", ":setlocal nospell<cr>", { desc = "spelling disable", noremap = true })

-- Multipane sizing
map("n", "<A-i>", "<cmd>vertical resize +2<cr>", { desc = "resize vertical +2", noremap = true })
map("n", "<A-o>", "<cmd>vertical resize -2<cr>", { desc = "resize vertical -2", noremap = true })
map("n", "<A-K>", "<cmd>horizontal resize +2<cr>", { desc = "resize horizontal +2", noremap = true })
map("n", "<A-J>", "<cmd>horizontal resize -2<cr>", { desc = "resize horizontal -2", noremap = true })

-- tabs/window navigation
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "tab new", noremap = true })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "tab close", noremap = true })
map("n", "<leader><tab>", "<cmd>tab tabNext<cr>", { desc = "tab next", noremap = true })
map("n", "<C-Q>", "<cmd>wincmd p | q<cr>", { desc = "window quit previous" })
-- buffer navigation
-- map("n", "<A-j>", "<cmd>bnext<cr>", { desc = "buffer goto next" })
-- map("n", "<A-k>", "<cmd>bprevious<cr>", { desc = "buffer goto prev" })

-- Nvchad tabufline navigation
map("n", "<A-j>", function()
	require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<A-k>", function()
	require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

-- Keymaps
map("n", "<leader>wm", "<cmd>Telescope keymaps<cr>", { desc = "which keymap" })

-- Disable mappings
local nomap = vim.keymap.del
nomap("n", "<leader>h") -- disable horizontal term
nomap("n", "<leader>e") -- disable nvimtree focus

-- ProjectMgr
-- map("n", "<leader>fp", ":ProjectMgr<cr>", { desc = "Open Projects" })
