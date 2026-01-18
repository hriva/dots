-- vim.o.guifont = "Commit Mono NF:h16" -- text below applies for VimScript
-- vim.o.guifont = "GeistMono Nerd Font:h16"
vim.o.linespace = -3
vim.g.neovide_confirm_quit = true
vim.g.neovide_detach_on_quit = "prompt"

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
--
if not is_windows then
	vim.env.PATH = table.concat({ vim.fn.expand("~"), ".local", "bin" }, sep) .. delim .. vim.env.PATH
	-- vim.env.PATH = table.concat({ vim.fn.expand("~"), ".local", "share", "fnm", "aliases", "latest", "bin" }, sep)
	-- .. delim
	-- .. vim.env.PATH
	-- vim.env.BIOME_CONFIG_PATH = table.concat({ vim.fn.expand("~"), ".config", "biome", "biome.json" }, sep)
end

-- lua/set_cwd_from_arg.lua
local M = {}

function M.set_cwd_from_first_arg()
	local args = vim.fn.argv()
	if #args == 0 then
		return
	end

	local first_arg = args[1]
	local path = vim.fn.fnamemodify(first_arg, ":p:h")

	vim.fn.chdir(path)
	-- Run a custom post-init function
	M.start_app()
end

function M.start_app()
	-- Example: automatically start insert mode or Telescope
	-- vim.cmd("startinsert")
	-- require('telescope.builtin').find_files()
end

return M
