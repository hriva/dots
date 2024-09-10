local fast_event_aware_notify = function(msg, level, opts)
	if vim.in_fast_event() then
		vim.schedule(function()
			vim.notify(msg, level, opts)
		end)
	else
		vim.notify(msg, level, opts)
	end
end

local M = {}

function M.info(msg)
	fast_event_aware_notify(msg, vim.log.levels.INFO, {})
end

function M.warn(msg)
	fast_event_aware_notify(msg, vim.log.levels.WARN, {})
end

-- TODO: Set bps per file for small json
local BP_DB_PATH = vim.fn.stdpath("data") .. "/dap_bps.json"

M._load_bps = function()
	local fp = io.open(BP_DB_PATH, "r")
	if not fp then
		M.info("No breakpoint json-db present.")
		return
	end
	local json = fp:read("*a")
	local ok, bps = pcall(vim.json.decode, json)
	if not ok or type(bps) ~= "table" then
		M.warn(string.format("Error parsing breakpoint json-db: %s", bps))
		return
	end
	local path2bufnr = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local path = vim.api.nvim_buf_get_name(bufnr)
		if type(bps[path]) == "table" and not vim.tbl_isempty(bps[path]) then
			path2bufnr[path] = bufnr
		end
	end
	-- no breakpoints in current buflist
	if vim.tbl_isempty(path2bufnr) then
		return
	end
	local bp_count = 0
	for path, buf_bps in pairs(bps) do
		local bufnr = tonumber(path2bufnr[path])
		if bufnr then
			for _, bp in pairs(buf_bps) do
				bp_count = bp_count + 1
				local line = bp.line
				local opts = {
					condition = bp.condition,
					log_message = bp.logMessage,
					hit_condition = bp.hitCondition,
				}
				require("dap.breakpoints").set(opts, bufnr, line)
			end
		end
	end
	-- Load bps into active session (not just the UI)
	local session = require("dap").session()
	if session and bp_count > 0 then
		session:set_breakpoints(require("dap.breakpoints").get())
	end
	M.info(string.format("Loaded %d breakpoints in %d bufers.", bp_count, vim.tbl_count(path2bufnr)))
end

M._store_bps = function()
	local fp = io.open(BP_DB_PATH, "r")
	local json = fp and fp:read("*a") or "{}"
	local ok, bps = pcall(vim.json.decode, json)
	if not ok or type(bps) ~= "table" then
		bps = {}
	end
	local bp_count = 0
	local breakpoints_by_buf = require("dap.breakpoints").get()
	for bufnr, buf_bps in pairs(breakpoints_by_buf) do
		bp_count = bp_count + 1
		bps[vim.api.nvim_buf_get_name(bufnr)] = buf_bps
	end
	-- If buffer has no breakpoints, remove from the db
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if not breakpoints_by_buf[bufnr] then
			local path = vim.api.nvim_buf_get_name(bufnr)
			bps[path] = nil
		end
	end
	fp = io.open(BP_DB_PATH, "w")
	if fp then
		fp:write(vim.json.encode(bps))
		fp:close()
		M.info(string.format("Stored %d breakpoints in %d bufers.", bp_count, vim.tbl_count(breakpoints_by_buf)))
	end
end

vim.keymap.set({ "n", "v" }, "<leader>dl", M._load_bps, { silent = true, desc = "dap load breakpoints" })
vim.keymap.set({ "n", "v" }, "<leader>dd", M._store_bps, { silent = true, desc = "dap dump breakpoints" })

return M

-- credits to https://github.com/Dan7h3x/SciVim/
