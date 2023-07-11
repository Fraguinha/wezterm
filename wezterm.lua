-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Functions
local function isViProcess(pane)
    return pane:get_foreground_process_name():find('n?vim') ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) then
        window:perform_action(
        -- This should match the keybinds you set in Neovim.
            wezterm.action.SendKey({ key = vim_direction, mods = 'CTRL' }),
            pane
        )
    else
        window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
    end
end

-- Event handlers
wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
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
config.color_scheme = 'Catppuccin Mocha'

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 14

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

-- Keybindings
config.disable_default_key_bindings = true
config.keys = {
    {
        key = 'l',
        mods = 'CTRL',
        action = wezterm.action.Multiple {
            wezterm.action.ClearScrollback 'ScrollbackAndViewport',
            wezterm.action.SendKey { key = 'l', mods = 'CTRL' },
        },
    },
    {
        key = 'Return',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ToggleFullScreen,
    },
    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CopyTo "Clipboard",
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.PasteFrom "Clipboard",
    },
    {
        key = 'h',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent('ActivatePaneDirection-left'),
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent('ActivatePaneDirection-down'),
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent('ActivatePaneDirection-up'),
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent('ActivatePaneDirection-right'),
    },
    {
        key = 'r',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'd',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'x',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
}

-- and finally, return the configuration to wezterm
return config
