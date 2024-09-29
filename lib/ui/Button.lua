local GUI = require("gui")
local expect = require("lib.expect")

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
        constructor.width = GUI.len(constructor.text) + 2
    end

    if not constructor.height then
        constructor.height = 2
    end

    expect(constructor.x, "number")
    expect(constructor.y, "number")
    expect(constructor.width, "number")
    expect(constructor.height, "number")
    expect(constructor.onClick, "function")

    setmetatable(constructor, self)
    self.__index = self

    return constructor
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
        self:onClick(self)
    end
end
