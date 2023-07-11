local wezterm = require("wezterm")

local M = {}

function M.setup(config)
	config.keys = {
		-- Wezterm
		{ key = "x", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
		{ key = "Delete", mods = "CTRL|SHIFT", action = wezterm.action.ShowDebugOverlay },
		-- Copy Paste
		{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		-- Scroll
		{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByLine(-1) },
		{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByLine(1) },
		-- Zoom
		{ key = "+", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
		{ key = "_", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
		-- Spliting
		{ key = "%", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		-- Navigation
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("fraguinha.ActivatePaneDirection.Left") },
		{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("fraguinha.ActivatePaneDirection.Down") },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("fraguinha.ActivatePaneDirection.Up") },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("fraguinha.ActivatePaneDirection.Right") },
		-- Resize
		{ key = "h", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "j", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "k", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "l", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
		-- Sessions
		{
			key = "Backspace",
			mods = "CTRL|SHIFT",
			action = wezterm.action.EmitEvent("fraguinha.SelectWorkspace"),
		},
		-- Tabs
		{
			key = "Return",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},
		{ key = "<", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
		{ key = ">", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },
		-- Search
		{
			key = "f",
			mods = "CTRL|SHIFT",
			action = wezterm.action.Search({ CaseInSensitiveString = "" }),
		},
		-- Regex
		{
			key = "r",
			mods = "CTRL|SHIFT",
			action = wezterm.action.QuickSelect,
		},
		-- Copy
		{
			key = "Space",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateCopyMode,
		},
	}

	-- Tab Selection
	for i = 1, 12 do
		table.insert(config.keys, {
			key = "F" .. tostring(i),
			action = wezterm.action.ActivateTab(i - 1),
		})
	end

	config.key_tables = {
		search_mode = {
			{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("NextMatch") },
			{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("PriorMatch") },
			{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.CopyMode("CycleMatchType") },
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
		copy_mode = wezterm.gui.default_key_tables().copy_mode,
	}
end

return M
