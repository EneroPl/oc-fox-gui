local shell = require("shell")
local config = require("config")
print("lib/github.lua " .. config.GITHUB_USERNAME .. " " .. config.GITHUB_REPO .. " " .. config.GITHUB_AUTH_TOKEN)
shell.execute("lib/github " .. config.GITHUB_USERNAME .. " " .. config.GITHUB_REPO .. " " .. config.GITHUB_AUTH_TOKEN)
