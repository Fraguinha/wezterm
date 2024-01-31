local wezterm = require("wezterm")

-- Personal
local functions = require("fraguinha.functions")
local handlers = require("fraguinha.handlers")
local keybinds = require("fraguinha.keybinds")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Event handlers
handlers.setup()

-- Keybindings
config.disable_default_key_bindings = true
keybinds.setup(config)

-- Theme
config.color_scheme = functions.choose_theme()

-- Font
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.warn_about_missing_glyphs = false
if functions.is_macos() then
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
config.scrollback_lines = 100000

-- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Feedzai
table.insert(config.hyperlink_rules, {
	regex = [[([A-Z]{2,}-[0-9]+)]], -- JIRA issue
	format = "https://fdz.atlassian.net/browse/$1",
})

-- Quick Copy
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
	[[[^ /"']*(?<!:/)(?:/[^ /"']+)+/?]], -- linux paths
	[[[0-9]+\\.[0-9]+\\.[0-9]+]], -- semantic version
	[[[0-9a-f]{6,40}]], -- sha1 hash
	[["[^"]*"]], -- double quote string
	[['[^']*']], -- single quote string
}

return config
