local functions = require("fraguinha.functions")

local M = {}

M.home = os.getenv("HOME")

-- Select Workspace
if functions.is_macos() then
	M.fd = "/usr/local/bin/fd"
else
	M.fd = "fd"
end

M.workspace_paths = {
	M.home .. "/workspace/",
	M.home .. "/.config/",
}

M.workspace_exclusions = {
	"feedzai/feedzai/developer-training/",
}

return M
