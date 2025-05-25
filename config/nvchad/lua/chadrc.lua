---@type ChadrcConfig
local M = {
	base46 = {
		theme = "github_light",
		theme_toggle = { "ayu_dark", "github_light" },
		hl_override = {
			DiffAdd = { bg = "#4c6b0f", fg = "#fafaff" }, -- green
			DiffDelete = { bg = "#661d00", fg = "#fafaff" }, -- red
			DiffChange = { bg = "#665000", fg = "#fafaff" }, -- yellow
			DiffText = { bg = "#a75106", fg = "#fafaff" }, -- orange
		},
	},
	ui = {
		statusline = {
			theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		},
	},

	lsp = { signature = false },
	nvdash = {
		load_on_startup = true,
		header = {
			"                            ",
			"     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
			"   ▄▀███▄     ▄██ █████▀    ",
			"   ██▄▀███▄   ███           ",
			"   ███  ▀███▄ ███           ",
			"   ███    ▀██ ███           ",
			"   ███      ▀ ███           ",
			"   ▀██ █████▄▀█▀▄██████▄    ",
			"     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
			"                            ",
			"     Powered By  eovim    ",
			"                            ",
		},

		buttons = {
			{ txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
			{ txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
			{ txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
			{ txt = "󱥚  Themes", keys = "Spc t h", cmd = "Telescope themes" },
			{ txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },
			{ txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

			{
				txt = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime) .. " ms"
					return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
				end,
				hl = "NvDashLazy",
				no_gap = true,
			},

			{ txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
		},
	},
	mason = {
		pkgs = {
			"debugpy",
		},
	},
}

return M
