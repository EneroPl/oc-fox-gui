local GUI = require("lib.gui")
local expect = require("lib.expect")

local ICON_STATE = {
    [true] = "▣",
    [false] = "□"
}

Checkbox = {
    _listeners = {"touch"},
    x = 0,
    y = 0,
    text = "",
    value = false,
    onClick = function()
        return false
    end
}

function Checkbox:new(constructor)
    constructor = constructor or {}

    setmetatable(constructor, self)
    self.__index = self

    return constructor
end

function Checkbox:draw()
    GUI.fill(self.x, self.y, GUI.len(self.text) + 2, 1, " ")

    local color = self.value and 0xF7C815 or 0xA2B6B5

    GUI.text(self.x, self.y, self.text)
    GUI.text(self.x + GUI.len(self.text) + 1, self.y, ICON_STATE[self.value], color)
end

function Checkbox:onEvent(_, _, x, y)
    if GUI.isClickInside(x, y, self.x, self.y, self.x + GUI.len(self.text), self.y) then
        self.value = not self.value
        self:onClick(self)
        self:draw()
    end
end
