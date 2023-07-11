local wezterm = require("wezterm")

local functions = require("fraguinha.functions")
local constants = require("fraguinha.constants")

local M = {}

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
	if functions.is_vi_process(pane) then
		window:perform_action(wezterm.action.SendKey({ mods = "CTRL|SHIFT", key = vim_direction }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

local function select_workspace(window, pane)
	local home = constants.home

	local fd = constants.fd
	local workspace = constants.workspace_paths
	local exclusions = constants.workspace_exclusions

	local command = {
		fd,
		"--regex",
		"^\\.git$",
		"--hidden",
		"--no-ignore-vcs",
		"--type=d",
		"--max-depth=6",
	}

	for _, path in ipairs(exclusions) do
		table.insert(command, "--exclude=" .. path)
	end

	for _, path in ipairs(workspace) do
		table.insert(command, path)
	end

	local success, stdout, stderr = wezterm.run_child_process(command)

	if not success then
		wezterm.log_error(stderr)
		return
	end

	local projects = {}

	table.insert(projects, { label = "default", id = "default" })

	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("/.git/?$", "")
		local id = project:gsub(".*/", "")
		local label = project:gsub(home, "~")
		table.insert(projects, { id = tostring(id), label = tostring(label) })
	end

	window:perform_action(
		wezterm.action.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					return
				else
					local cwd = label:gsub("~", home)
					win:perform_action(wezterm.action.SwitchToWorkspace({ name = id, spawn = { cwd = cwd } }), pane)
				end
			end),
			title = "Workspace",
			fuzzy_description = "Workspace to switch: ",
			choices = projects,
			fuzzy = true,
		}),
		pane
	)
end

function M.setup()
	-- Maximize on linux
	wezterm.on("gui-startup", function(cmd)
		if not functions.is_linux() then
			return
		end
		local _, _, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end)

	-- Navigation
	wezterm.on("fraguinha.ActivatePaneDirection.Left", function(window, pane)
		conditional_activate_pane(window, pane, "Left", "h")
	end)
	wezterm.on("fraguinha.ActivatePaneDirection.Down", function(window, pane)
		conditional_activate_pane(window, pane, "Down", "j")
	end)
	wezterm.on("fraguinha.ActivatePaneDirection.Up", function(window, pane)
		conditional_activate_pane(window, pane, "Up", "k")
	end)
	wezterm.on("fraguinha.ActivatePaneDirection.Right", function(window, pane)
		conditional_activate_pane(window, pane, "Right", "l")
	end)

	-- Workspaces
	wezterm.on("fraguinha.SelectWorkspace", function(window, pane)
		select_workspace(window, pane)
	end)
end

return M
