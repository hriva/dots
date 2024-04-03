local api = vim.api
local map = vim.keymap.set
local session_file = "Session.vim"

local function file_exists(name)
	if name == nil then
		return false
	end
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

if file_exists(session_file) then
	api.nvim_command("so " .. session_file)
end

-- api.nvim_command("augroup SessionManagement")
-- api.nvim_command("autocmd!")
-- api.nvim_command("autocmd VimLeavePre * lua require'session'.on_buf_leave()")
-- api.nvim_command("augroup END")

local session_augroup = vim.api.nvim_create_augroup("SessionManagement", { clear = true })
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	group = session_augroup,
	pattern = "*",
	callback = function()
		if file_exists(session_file) then
			api.nvim_exec(
				[[
					for l in range(1, bufnr('$'))
					if bufexists(l) && !buflisted(l)
					silent! exec 'bd ' . l
					endif
					endfor
					]],
				false
			)
			api.nvim_command("set sessionoptions-=options")
			api.nvim_command("mksession! " .. session_file)
		end
	end,
})

map("n", "<C-y>", function()
	api.nvim_command("set sessionoptions-=options")
	api.nvim_command("mksession! " .. session_file)
	vim.print(session_file .. " Created")
end, { desc = "Make Session" })
