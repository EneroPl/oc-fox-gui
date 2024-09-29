local component = require("component")
local unicode = require("unicode")

local GUI = require("gui")

local gpu = component.gpu

Button = {
    _listeners = {"touch"},
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    text = "",
    onClick = function()
        return false
    end
}

function Button:new(constructor)
    constructor = constructor or {}

    if not constructor.width then
        constructor.width = unicode.len(constructor.text) + 2
    end

    if not constructor.height then
        constructor.height = 2
    end

    setmetatable(constructor, self)
    self.__index = self

    return constructor
end

function Button.eventValidator(self, x, y)
    local insideX = x >= self.x and x <= self.x + self.width
    local insideY = y >= self.y and y <= self.y + self.height

    return insideX and insideY
end

function Button:draw()
    GUI.box(self.x, self.y, self.width + 1, self.height)
    GUI.centerText(self.x + 1, self.y + 1, self.width, self.text)
end

function Button:validateClick(x, y)
    local isInX = x >= self.x and x <= self.x + self.width;
    local isInY = y >= self.y and y <= self.y + self.height;

    return isInX and isInY;
end

function Button:onEvent(_, _, x, y)
    local isValidClick = self:validateClick(x, y)

    if isValidClick then
        local needRedraw = self:onClick()
        if needRedraw then
            self:draw()
        end
    end
end

return Button
