local internet = require("internet")
require('utils.common')

Http = {
    url = nil,
    headers = {
        ["Content-Type"] = "application/json"
    }
}
Http.__index = Http

function Http:new(constructor)
    constructor = constructor or {}
    setmetatable(constructor, self)
    self.__index = self
    return constructor
end

function Http:send(message)
    if type(message) ~= "string" then
        local str = "";

        message = "{" .. tableToString(message):gsub("[%w_]+", '"%1"'):gsub("=", ":") .. "}"
    end

    local response = internet.request(self.url, message, self.headers)
    os.sleep(0.1)

    if response.data then
        return response.data
    end

    return response
end
