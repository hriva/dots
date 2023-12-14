-- local wezterm = require("wezterm")
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- maximize window on statup
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

local function font_with_fallback(name, params)
	local names = { name, "Apple Color Emoji", "azuki_font" }
	return wezterm.font_with_fallback(names, params)
end

-- local font_name = "SF Mono"
local colors = require('lua/green-on-black').colors()
local window_frame = require('lua/green-on-black').window_frame()

return {
	-- OpenGL for GPU acceleration, Software for CPU
	front_end = "OpenGL",

	color_scheme = 'green-on-black',
	colors = colors,
	window_frame = window_frame, -- needed only if using fancy tab bar

	-- Font config
	font = font_with_fallback(
    font_name,
    {weight="Regular", stretch="Normal", style="Normal", bold = false}),

	font_rules = {
    {
			italic = true,
			font = font_with_fallback(font_name, { italic = true }),
		},
		{
			italic = false,
			font = font_with_fallback(font_name, { bold = false }),
		},
		{
			intensity = "Normal",
			font = font_with_fallback(font_name, {weight='Regular', bold = false }),
		},
	},
	warn_about_missing_glyphs = false,
	font_size = 16,
	line_height = 1.0,
	dpi = 99.0,

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
             action = wezterm.action.SpawnCommandInNewWindow {
             args = {},
             },
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
		left = 10,
		right = 12,
		top = 12,
		bottom = 12,
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
	window_background_opacity = .92,
	window_close_confirmation = 'AlwaysPrompt',
	window_decorations = "RESIZE",
}
