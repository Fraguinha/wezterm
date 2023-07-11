local wezterm = require("wezterm")

local M = {}

-- Private
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Light"
end

-- Public
function M.is_macos()
	return wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin"
end

function M.is_linux()
	return wezterm.target_triple == "x86_64-unknown-linux-gnu"
end

function M.is_vi_process(pane)
	return pane:get_title():find("n?vim") ~= nil
end

function M.choose_theme()
	local appearance = get_appearance()

	if appearance:find("Light") then
		return "Catppuccin Latte"
	else
		return "Catppuccin Mocha"
	end
end

return M
