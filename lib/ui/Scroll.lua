local GUI = require("lib.gui")
local expect = require("lib.expect")

Scroll = {
    _listeners = {"scroll", "drag", "touch"},
    _scroll = {},
    position = 1,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    text = {}
}

function Scroll:new(constructor)
    constructor = constructor or {}
    constructor.position = constructor.position or 1

    if not constructor.width then
        constructor.width = 0;

        for i = 1, #constructor.text do
            if GUI.len(constructor.text[i]) > constructor.width then
                constructor.width = #constructor.text[i]
            end
        end
    end

    local x, y, width, height = constructor.x, constructor.y, constructor.width, constructor.height

    constructor._scroll = {
        x = x + width + 2,
        y = y,
        width = 1,
        height = y + height
    }

    expect(constructor.position, "number")
    expect(constructor.x, "number")
    expect(constructor.y, "number")
    expect(constructor.width, "number")
    expect(constructor.height, "number")
    expect(constructor.text, "table")

    setmetatable(constructor, self)
    self.__index = self

    return constructor
end

function Scroll:drawContent()
    for i = 1, self.height do
        local item = self.text[(self.position - 1) + i]

        if item == nil then
            break
        end

        GUI.text(self.x, (self.y + i) - 1, item)
    end
end

function Scroll:drawScoll()
    local sliderHeight = math.floor(math.pow(self.height, 2) / #self.text)
    local sliderPosition = math.floor(self.position * self.height / #self.text)

    -- Проверка на последнюю строку
    if #self.text - self.height - self.position >= 0 and sliderPosition == sliderHeight then
        sliderPosition = sliderPosition - 1
    end

    for i = 1, self.height do
        GUI.text(self._scroll.x, (self._scroll.y + i) - 1, " ", 'white', 0x123123)
    end

    GUI.fill(self._scroll.x, self._scroll.y + sliderPosition, 1, sliderHeight, "█")
end

function Scroll:draw()
    self:drawContent()
    self:drawScoll()
end

function Scroll:scrollTo(offset)
    if (offset == 200 or offset == 1) and self.position > 1 then -- Стрелка вверх
        self.position = self.position - 1
        self:draw()
    elseif offset == 208 or offset == -1 then -- Стрелка вниз
        if self.position < #self.text - self.height + 1 then
            self.position = self.position + 1
            self:draw()
        end
    end
end

function Scroll:setPosition(y)
    y = y - self.y

    if y == 0 then
        y = 1
    end

    if self.height + y == #self.text then
        y = #self.text - self.height + 1
    end

    self.position = y
    self:draw()
end

function Scroll:onEvent(arg1, arg2, arg3, arg4, arg5)
    local event = {arg1, arg2, arg3, arg4, arg5}
    local eventName = event[1]

    if eventName == "scroll" then
        local outOfWidth = arg3 < self.x or arg3 > self._scroll.x;
        local outOfHeight = arg4 < self.y or arg4 > self.y + self.height;

        if not outOfHeight and not outOfWidth then
            self:scrollTo(event[5])
        end
    elseif eventName == "drag" or eventName == "touch" then
        local outOfWidth = arg3 < self._scroll.x - 2 or arg3 > self._scroll.x + 2;
        local outOfHeight = arg4 < self._scroll.y or arg4 > self._scroll.height;

        if not outOfHeight and not outOfWidth then
            self:setPosition(event[4])
        end
    end
end
