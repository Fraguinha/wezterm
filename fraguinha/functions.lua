local wezterm = require("wezterm")

local module = {}

-- Private
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function is_vi_process(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

-- Public
function module.is_macos()
	return wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin"
end

function module.choose_theme()
	local appearance = get_appearance()

	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

function module.conditional_activate_pane(window, pane, pane_direction, vim_direction)
	if is_vi_process(pane) then
		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

return module
