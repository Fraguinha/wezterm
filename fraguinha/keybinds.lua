local wezterm = require("wezterm")

local module = {}

function module.setup(config)
	config.keys = {
		{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "%", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
		{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
		{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
		{
			key = "f",
			mods = "CTRL|SHIFT",
			action = wezterm.action.Search({ CaseInSensitiveString = "" }),
		},
		{
			key = "r",
			mods = "CTRL|SHIFT",
			action = wezterm.action.QuickSelect,
		},
		{
			key = "Return",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "Backspace",
			mods = "CTRL|SHIFT",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
		{
			key = "Space",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateCopyMode,
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
end

return module
