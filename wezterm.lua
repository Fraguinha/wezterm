local wezterm = require("wezterm")

-- Personal
local functions = require("fraguinha.functions")
local handlers = require("fraguinha.handlers")
local keybinds = require("fraguinha.keybinds")
local regex = require("fraguinha.regex")

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
config.warn_about_missing_glyphs = false
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.line_height = 1.2
if functions.is_macos() then
	config.font_size = 12
else
	config.font_size = 10
end

-- Window
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.native_macos_fullscreen_mode = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
if functions.is_linux() then
	config.enable_wayland = true
end

-- Scrollback
config.scrollback_lines = 100000

-- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Feedzai
table.insert(config.hyperlink_rules, {
	regex = regex.jira_ticket,
	format = "https://fdz.atlassian.net/browse/$1",
})

-- Quick Copy
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
	regex.linux_path,
	regex.ipv4,
	regex.semantic_version,
	regex.aws_instance,
	regex.sha1_hash,
	regex.single_quote_string,
	regex.double_quote_string,
}

return config
