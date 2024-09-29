local GUI = require("gui")
local expect = require("lib.expect")

Progress = {
    x = 0,
    y = 0,
    width = 0,
    title = nil,
    description = nil,
    value = 0,
    total = 0
}

function Progress:new(constructor)
    constructor = constructor or {}
    setmetatable(constructor, self)
    self.__index = self

    expect(constructor.x, "number")
    expect(constructor.y, "number")
    expect(constructor.width, "number")
    expect(constructor.value, "number")
    expect(constructor.total, "number")

    return constructor
end

function Progress:getFilledWidth()
    local percentage = self.value / self.total
    return math.floor(percentage * self.width)
end

function Progress:drawField()
    for i = self:getFilledWidth() + 1, self.width do
        GUI.text(self.x + i - 1, self.y, "▊")
    end
end

function Progress:drawFilledField()
    for i = 1, self:getFilledWidth() do
        GUI.text(self.x + i - 1, self.y, "▊", 0xFF0000)
    end
end

function Progress:draw()
    local percentage = self.value / self.total
    local filledWidth = math.floor(percentage * self.width)

    if self.title then
        GUI.centerText(self.x, self.y, self.width, self.title)
        self.y = self.y + 2
    end

    self:drawField();
    self:drawFilledField()

    if self.description then
        GUI.centerText(self.x, self.y + 2, self.width, self.description)
    end
end

function Progress:update(value)
    if value > self.total then
        return
    end

    self.value = value
    self:drawFilledField()
end
