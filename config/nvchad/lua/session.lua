local M = {}
M.sessionFile = "Session.vim"

-- Check if session file is present
local function sessionFileExists()
	local sessionFilePath = M.sessionFile
	return vim.fn.filereadable(sessionFilePath) == 1
end

-- Load session
local function loadSession()
	local sessionFilePath = M.sessionFile
	vim.cmd.source({
		args = { sessionFilePath },
		mods = { silent = false, emsg_silent = true },
	})
end

-- Save session
function M.saveSession()
	local sessionFilePath = M.sessionFile
	if vim.fn.exists(":NvimTreeClose") == 2 then
		vim.cmd("NvimTreeClose")
	end
	vim.cmd.mksession({ args = {
		sessionFilePath,
	}, bang = true })
	vim.print("created session file")
end

-- Auto load session when launching Neovim (with no arguments)
function M.autoLoadSession()
	if vim.fn.argc() == 0 then -- Check if there are no arguments
		if sessionFileExists() then
			loadSession()
		end
	end
end

-- Auto save session upon exit if session file was present and no arguments were provided
function M.autoSaveSession()
	if vim.fn.argc() == 0 then -- Check if there are no arguments
		if sessionFileExists() then
			vim.cmd('autocmd VimLeavePre * lua require("session").saveSession()')
		end
	end
end

-- Create session file with Ctrl+y keybinding
vim.api.nvim_set_keymap(
	"n",
	"<C-y>",
	'<cmd>lua require("session").saveSession()<CR>',
	{ desc = "Session Make", noremap = true, silent = true }
)

return M
