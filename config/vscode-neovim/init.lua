-- if vim.g.vscode then
vim.g.mapleader = " "

local map = vim.keymap.set

-- opts
local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.autoread = false -- sync buffers automatically
opt.swapfile = false -- disable swapfile and showing the error
opt.undofile = true

local vscode = require("vscode-neovim")

local function VS(cmd, opts)
	vscode.call(cmd, opts or {})
end

-- <C-n> :nohl
map("n", "<C-n>", function() vim.cmd("nohlsearch") end, { silent = true })


-- vim.normalModeKeyBindings keybindings

-- =========================
-- NAVIGATION (PANES / EDITORS)
-- =========================

map("n", "<C-h>", function() VS("workbench.action.navigateLeft") end)
map("n", "<C-j>", function() VS("workbench.action.navigateDown") end)
map("n", "<C-k>", function() VS("workbench.action.navigateUp") end)
map("n", "<C-l>", function() VS("workbench.action.navigateRight") end)

map("n", "<A-j>", function() VS("workbench.action.nextEditor") end)
map("n", "<A-k>", function() VS("workbench.action.previousEditor") end)

map("n", "<leader>x", function() VS("workbench.action.closeActiveEditor") end)

-- =========================
-- FILE / SEARCH
-- =========================

map("n", "<leader>ff", function() VS("workbench.action.quickOpen") end)
map("n", "<leader>fo", function() VS("workbench.action.quickOpenWithModes") end)
map("n", "<leader>fr", function() VS("workbench.action.openRecent") end)

map("n", "<leader>fR", function() VS("workbench.action.replaceInFiles", { async = true }) end)
map("n", "<leader>fw", function() VS("workbench.action.findInFiles", { async = true }) end)

map("n", "<leader>dt", function() VS("workbench.files.action.compareFileWith") end)

-- =========================
-- LSP
-- =========================

map("n", "K", function() VS("editor.action.showDefinitionPreviewHover") end)

map("n", "gD", function() VS("editor.action.revealDefinitionAside") end)
map("n", "gpd", function() VS("editor.action.peekDefinition") end)

map("n", "gh", function() VS("editor.action.showDefinitionPreviewHover") end)

map("n", "gi", function() VS("editor.action.goToImplementation") end)
map("n", "gpi", function() VS("editor.action.peekImplementation") end)

map("n", "gq", function() VS("editor.action.quickFix") end)

map("n", "gt", function() VS("editor.action.goToTypeDefinition") end)
map("n", "gpt", function() VS("editor.action.peekTypeDefinition") end)

map("n", "<leader>fs", function() VS("workbench.action.showAllSymbols",{ async = true }) end)

map("n", "gr", function() VS("references-view.findReferences",{ async = true }) end)
map("n", "gR", function() VS("editor.action.referenceSearch.trigger",{ async = true }) end)

map("n", "<leader>sd", function() VS("workbench.actions.view.toggleProblems") end)

-- =========================
-- GIT / DIAGNOSTICS
-- =========================

map("n", "[c", function() VS("workbench.action.editor.previousChange") end)
map("n", "]c", function() VS("workbench.action.editor.nextChange") end)

map("n", "]d", function() VS("editor.action.marker.nextInFiles") end)
map("n", "[d", function() VS("editor.action.marker.prevInFiles") end)

map("n", "<leader>gd", function() VS("git.openChange") end)
map("n", "<leader>gr", function() VS("git.revertSelectedRanges") end)
map("n", "<leader>gs", function() VS("git.stageSelectedRanges") end)
map("n", "<leader>gu", function() VS("git.unstageSelectedRanges") end)

-- =========================
-- EDITING
-- =========================

-- map("n", "u", function() VS("undo") end)
-- map("n", "<C-r>", function() VS("redo") end)

map("v", "J", ":m '>+1<CR>gv-gv", { desc = "move selection down" })
map("v", "K", ":m '<-2<CR>gv-gv", { desc = "move selection up" })
map("n", "J", "mzJ`z", { desc = "append in place" })

map("n", "<C-}>", function() VS("workbench.action.decreaseViewSize") end)
-- C-[ is escapes ascii code & conflicts
map("n", "<C-{>", function() VS("workbench.action.increaseViewSize") end)

map("n", "<leader>/", function() VS("editor.action.commentLine") end)
map("n", "p", "pgvy", { noremap = true, silent = true })

map("n", "<C-d>", "<C-d>zz", { desc = "page half down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "page half up centered" })
map("n", "n", "nzzzv", { desc = "next search and center" })
map("n", "N", "Nzzzv", { desc = "prev search and center" })
map("n", "x", '"_x', { noremap = true, silent = true, desc = "cut witouth clipboard" })

-- vim.visualModeKeyBindings

-- =========================
-- GIT / DIAGNOSTICS
-- =========================
map("x", "<leader>gr", function() VS("git.revertSelectedRanges") end)
map("x", "<leader>gs", function() VS("git.stageSelectedRanges") end)
map("x", "<leader>gu", function() VS("git.unstageSelectedRanges") end)

-- =========================
-- EDITING
-- =========================

map("x", "<leader>/", function() VS("editor.action.commentLine") end)
map("x", "x", '"_x', { noremap = true, silent = true, desc = "cut witouth clipboard" })
map("x", "<", "<gv", { noremap = true, silent = true })
map("x", ">", ">gv", { noremap = true, silent = true })

-- vim.visualModeKeyBindingsNonRecursive (special p)
map("x", "p", "pgvy", { noremap = true, silent = true })

-- end
