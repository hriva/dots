local wezterm = require("wezterm")

-- maximize window on statup
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

local function font_with_fallback(name, params)
	local names = { name, "JetBrains Mono" }
	return wezterm.font_with_fallback(names, params)
end

local font_name = "CommitMono Nerd Font"
local font_params = { weight = "Regular", stretch = "UltraCondensed", style = "Normal", bold = false }
local colors = require("lua/japanesque").colors()
local window_frame = require("lua/japanesque").window_frame()

return {
	set_environment_variables = {
		VTE_VERSION = "7402", -- vte version for fedora default vte.sh
	},
	notification_handling = "NeverShow", -- disbble notification_handling

	-- Font config
	font = font_with_fallback(font_name, font_params),

	font_rules = {
		{
			italic = true,
			font = font_with_fallback(font_name, { stretch = "UltraCondensed", italic = true }),
		},
		{
			italic = false,
			font = font_with_fallback(font_name, font_params),
		},
	},

	-- OpenGL for GPU acceleration, Software for CPU
	front_end = "OpenGL",

	color_scheme = "Japanesque",
	colors = colors,
	window_frame = window_frame, -- needed only if using fancy tab bar
	warn_about_missing_glyphs = false,
	font_size = 17,
	line_height = 1.01,
	cell_width = 0.90,
	-- dpi = 192.0, -- For 4K HD in wayland

	-- Cursor style
	default_cursor_style = "BlinkingBlock",

	-- X11
	enable_wayland = true,

	-- Keybinds
	disable_default_key_bindings = true,
	keys = {
		{
			key = "n",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SpawnCommandInNewWindow({
				args = {},
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = [[/]],
			mods = "CTRL",
			action = wezterm.action({
				SplitHorizontal = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = [[/]],
			mods = "CTRL|ALT",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "q",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
		},
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "k",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "j",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "h",
			mods = "CTRL|SHIFT|ALT",
			action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT|ALT",
			action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }),
		},
		{
			key = "k",
			mods = "CTRL|SHIFT|ALT",
			action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }),
		},
		{
			key = "j",
			mods = "CTRL|SHIFT|ALT",
			action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }),
		},
		{ -- browser-like bindings for tabbing
			key = "t",
			mods = "CTRL",
			action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
		},
		{
			key = "Tab",
			mods = "CTRL",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "Tab",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		}, -- standard copy/paste bindings
		-- {
		-- 	key = "x",
		-- 	mods = "CTRL",
		-- 	action = "ActivateCopyMode",
		-- },
		{
			key = "v",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ PasteFrom = "Clipboard" }),
		},
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
		},
	},

	-- Aesthetic Night Colorscheme
	bold_brightens_ansi_colors = true,
	-- Padding
	window_padding = {
		left = 11,
		right = 11,
		top = 11,
		bottom = 11,
	},
	initial_cols = 90,
	initial_rows = 22,

	-- Tab Bar
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	show_tab_index_in_tab_bar = false,
	tab_bar_at_bottom = true,

	-- General
	automatically_reload_config = true,
	inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
	window_background_opacity = 1.00,
	window_close_confirmation = "AlwaysPrompt",
	window_decorations = "RESIZE",
}
