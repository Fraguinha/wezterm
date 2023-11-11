-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Functions
local function is_macos()
	return wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin"
end

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local function is_vi_process(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
	if is_vi_process(pane) then
		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

-- Event handlers
wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditional_activate_pane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditional_activate_pane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditional_activate_pane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditional_activate_pane(window, pane, "Down", "j")
end)

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Theme
config.color_scheme = scheme_for_appearance(get_appearance())

-- Font
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
if is_macos() then
	config.font_size = 12
else
	config.font_size = 10
end

-- Window
config.native_macos_fullscreen_mode = true
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Scrollback
config.scrollback_lines = 50000

-- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Feedzai
table.insert(config.hyperlink_rules, {
	regex = "([A-Z]{2,}-[0-9]+)", -- JIRA issue
	format = "https://fdz.atlassian.net/browse/$1",
})

-- Quick Copy
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
	"[a-f0-9]{6,}", -- git commit hash
	"[0-9]+\\.[0-9]+\\.[0-9]+", -- semantic version
	"[a-zA-Z0-9-_\\.]*(?<!:/)(?:/[a-zA-Z0-9-_\\.]+)+/?", -- path
}

-- Keybindings
config.disable_default_key_bindings = true
config.keys = {
	{ key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "%", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
	{ key = "u", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByPage(0.5) },
	{ key = ")", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },
	{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
	{ key = "+", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
	{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = wezterm.action.Multiple({
			wezterm.action.CopyMode("ClearPattern"),
			wezterm.action.CopyMode("ClearSelectionMode"),
			wezterm.action.ActivateCopyMode,
		}),
	},
	{
		key = "l",
		mods = "CTRL",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "l", mods = "CTRL" }),
		}),
	},
}
config.key_tables = {
	search_mode = {
		{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("CycleMatchType") },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("ClearPattern") },
		{
			key = "Escape",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyMode("ClearPattern"),
				wezterm.action.CopyMode("Close"),
			}),
		},
	},
	copy_mode = {
		{ key = "Space", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "$", mods = "NONE", action = wezterm.action.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToEndOfLineContent") },
		{ key = ",", mods = "NONE", action = wezterm.action.CopyMode("JumpReverse") },
		{ key = "0", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLine") },
		{ key = ";", mods = "NONE", action = wezterm.action.CopyMode("JumpAgain") },
		{ key = "F", mods = "SHIFT", action = wezterm.action.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "G", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToScrollbackBottom") },
		{ key = "H", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportTop") },
		{ key = "L", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportBottom") },
		{ key = "M", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToViewportMiddle") },
		{ key = "O", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "T", mods = "SHIFT", action = wezterm.action.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "V", mods = "SHIFT", action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "^", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = wezterm.action.CopyMode("MoveToStartOfLineContent") },
		{ key = "b", mods = "NONE", action = wezterm.action.CopyMode("MoveBackwardWord") },
		{ key = "d", mods = "CTRL", action = wezterm.action.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "e", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWordEnd") },
		{ key = "f", mods = "NONE", action = wezterm.action.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "g", mods = "NONE", action = wezterm.action.CopyMode("MoveToScrollbackTop") },
		{ key = "h", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },
		{ key = "o", mods = "NONE", action = wezterm.action.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "t", mods = "NONE", action = wezterm.action.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "u", mods = "CTRL", action = wezterm.action.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "v", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "CTRL", action = wezterm.action.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "w", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
		{
			key = "y",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
				wezterm.action.CopyMode("ClearPattern"),
				wezterm.action.CopyMode("Close"),
			}),
		},
		{
			key = "Escape",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyMode("ClearPattern"),
				wezterm.action.CopyMode("Close"),
			}),
		},
	},
}

-- and finally, return the configuration to wezterm
return config
