---@type ChadrcConfig
local M = {
	base46 = { theme = "ayu_dark" },
	ui = {
		statusline = {
			theme = "minimal", -- default/vscode/vscode_colored/minimal
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
}

return M
