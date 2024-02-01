local module = {}

module.linux_path = [[[a-zA-Z0-9._-]*(?<!:/)(?:/[a-zA-Z0-9._-]+)+/?]]

module.ipv4 = [[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}]]

module.semantic_version = [[\d+\.\d+\.\d+]]

module.jira_ticket = [[([A-Z]{2,}-\d+)]]

module.aws_instance = [[i-[0-9a-f]{17}]]

module.sha1_hash = [[[0-9a-f]{6,40}]]

module.single_quote_string = [['[^']*']]

module.double_quote_string = [["[^"]*"]]

return module
