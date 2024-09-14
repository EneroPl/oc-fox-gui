local GitHub = require("lib.github")
local config = require("config")

GitHub.AUTH_TOKEN = config.GITHUB_AUTH_TOKEN
GitHub.USERNAME = config.GITHUB_USERNAME
GitHub.REPO = config.GITHUB_REPO

GitHub.clone()
