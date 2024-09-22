---@type ChadrcConfig
local M = {
	base46 = {
		theme = "ayu_dark",
		hl_override = {
			DiffAdd = { bg = { "green", -50 }, fg = "NONE" },
			DiffDelete = { bg = { "red", -50 }, fg = "NONE" },
			DiffChange = { bg = { "yellow", -47 }, fg = "NONE" },
			DiffText = { bg = { "orange", -45 }, fg = "NONE" },
		},
	},
	ui = {
		statusline = {
			theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		},
		nvdash = {
			load_on_startup = true,

			header = {
				" █████  █████ ██████   █████ █████ █████ █████",
				"░░███  ░░███ ░░██████ ░░███ ░░███ ░░███ ░░███ ",
				" ░███   ░███  ░███░███ ░███  ░███  ░░███ ███  ",
				" ░███   ░███  ░███░░███░███  ░███   ░░█████   ",
				" ░███   ░███  ░███ ░░██████  ░███    ███░███  ",
				" ░███   ░███  ░███  ░░█████  ░███   ███ ░░███ ",
				" ░░████████   █████  ░░█████ █████ █████ █████",
				"  ░░░░░░░░   ░░░░░    ░░░░░ ░░░░░ ░░░░░ ░░░░░ ",
			},

			buttons = {
				{ "  Find File", "Spc f f", "Telescope find_files" },
				{ "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
				{ "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
				{ "  Bookmarks", "Spc m a", "Telescope marks" },
				{ "  Themes", "Spc t h", "Telescope themes" },
				{ "  Mappings", "Spc c h", "NvCheatsheet" },
			},
		},
	},
	mason = {
		pkgs = {
			-- python
			"debugpy",
		},
	},
}

return M
