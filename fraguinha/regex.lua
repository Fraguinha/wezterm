local M = {}

-- Path
M.path = [[(?:[.\w\-@~]+)?(?:/+[.\w\-@]+)+]]

-- URL
M.url = [[(?:https?://|git@|git://|ssh://|ftp://|file://)\S+]]

-- IP
M.ipv4 = [[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}]]
M.ipv6 = [[[A-f0-9:]+:+[A-f0-9:]+[%\w\d]+]]

-- UUID
M.uuid = [[[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}]]

-- Hashes
M.sha1 = [[[0-9a-f]{7,40}]]

-- Versioning
M.semantic_version =
	[[(?:[0-9]+)\.(?:[0-9]+)\.(?:[0-9]+)(?:-(?:[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?]]

-- Conventional commits
M.conventional_commit =
	[[(?:build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test){1}(?:\([\w\-\.]+\))?(?:!)?: (?:[\w ])+(?<!\s)]]

-- Docker
M.docker = [[sha256:([0-9a-f]{64})]]

-- Jira
M.jira_ticket = [[([A-Z]{2,}-\d+)]]

-- AWS
M.aws_instance = [[i-[0-9a-f]{17}]]

return M
