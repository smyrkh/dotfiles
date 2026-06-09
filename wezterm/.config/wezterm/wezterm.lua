local wezterm = require 'wezterm'
local config = wezterm.config_builder()

------------------------------
-- window settings
------------------------------
-- color scheme
config.color_scheme = 'tokyonight_night'

-- window size
config.initial_rows = 45
config.initial_cols = 160

-- window transparent
config.window_background_opacity = 0.85

-- delete title bar
config.window_decorations = "RESIZE"

-- delete add tab button
config.show_new_tab_button_in_tab_bar = false

-- delete close tab button
-- Nightly Builds Only
-- config.show_close_tab_button_in_tabs = false

-- delete tab index
config.show_tab_index_in_tab_bar = false

-- show scroll bar
config.enable_scroll_bar = true

-- scroll backline
config.scrollback_lines = 10000

------------------------------
-- font settings
------------------------------
wezterm.font("HackGen Console NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 14

------------------------------
-- sound settings
------------------------------
config.audible_bell = 'Disabled'

------------------------------
-- mouse settings
------------------------------
config.mouse_bindings = {
	-- disable the default click behavior
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.Nop,
	},
}

------------------------------
-- keymap settings
------------------------------
config.keys = {
	{ key = "q", mods = "CTRL",       action = wezterm.action.ActivateCopyMode },

	{ key = "[", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "]", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(1) },

	{ key = 't', mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab { cwd = wezterm.home_dir, domain = 'CurrentPaneDomain' } },
	{ key = 'n', mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewWindow { cwd = wezterm.home_dir } },
}

return config
