local shell = require("shell")
local config = require("config")

shell.execute("lib/github " .. config.GITHUB_USERNAME .. " " .. config.GITHUB_REPO .. " " .. config.GITHUB_AUTH_TOKEN)
