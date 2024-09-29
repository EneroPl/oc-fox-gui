local component = require("component")
local unicode = require("unicode")

local GUI = require("gui")

local gpu = component.gpu

Progress = {
    x = 0,
    y = 0,
    width = 0,
    height = 1,
    title = nil,
    text = nil,
    completeText = nil,
    value = 0,
    total = 0,
    percentage = false
}

function Progress:new(constructor)
    constructor = constructor or {}
    setmetatable(constructor, self)
    self.__index = self

    return constructor
end

function Progress:draw()
    local percentage = self.value / self.total
    local filledWidth = math.floor(percentage * self.width)

    for i = filledWidth + 1, self.width do
        GUI.text(self.x + i - 1, self.y, "▊")
    end

    for i = 1, filledWidth do
        GUI.text(self.x + i - 1, self.y, "▊", 0xFF0000)
    end

    if self.title then
        GUI.centerText(self.x, self.y - 2, self.width, self.title)
    end

    if self.text then
        GUI.centerText(self.x, self.y + 2, self.width, self.text, 0x777777)
    end

    if self.percentage then
        GUI.text(self.x + self.width + 1, self.y, tostring(math.floor(percentage * 100 + 0.5)) .. "%")
    end
end

function Progress:update(value)
    if value > self.total then
        return
    end

    self.value = value
    self:draw()
end
