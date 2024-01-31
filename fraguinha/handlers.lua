local wezterm = require("wezterm")

local functions = require("fraguinha.functions")

local module = {}

function module.setup()
	wezterm.on("ActivatePaneDirection-right", function(window, pane)
		functions.conditional_activate_pane(window, pane, "Right", "l")
	end)
	wezterm.on("ActivatePaneDirection-left", function(window, pane)
		functions.conditional_activate_pane(window, pane, "Left", "h")
	end)
	wezterm.on("ActivatePaneDirection-up", function(window, pane)
		functions.conditional_activate_pane(window, pane, "Up", "k")
	end)
	wezterm.on("ActivatePaneDirection-down", function(window, pane)
		functions.conditional_activate_pane(window, pane, "Down", "j")
	end)
end

return module
