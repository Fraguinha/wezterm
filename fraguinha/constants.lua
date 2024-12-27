local M = {}

M.home = os.getenv("HOME")

M.workspace_paths = {
	M.home .. "/workspace/",
	M.home .. "/.config/",
}

M.workspace_exclusions = {
	"feedzai/feedzai/developer-training/",
}

return M
