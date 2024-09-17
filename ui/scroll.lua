local component = require("component")
local unicode = require("unicode")

local gpu = component.gpu

Scroll = {
    _position = 1,
    _scroll = {
        x = 0,
        y = 0,
        x2 = 0,
        y2 = 0,
        width = 1
    },
    width = 0,
    height = 0,
    lines = {}
}

function Scroll:new(constructor)
    constructor = constructor or {}
    constructor.scrollX = constructor.scrollX or 2;

    -- Получаем максимальную ширину контента
    -- и используем её в качестве ширины компонента,
    -- если не задано пользовательское значение
    if not constructor.width then
        constructor.width = 0;

        for i = 1, #constructor.lines do
            if unicode.len(constructor.lines[i]) > constructor.width then
                constructor.width = #constructor.lines[i]
            end
        end
    end
    -- Получаем координаты скролла
    local x, y, width, height = constructor.x, constructor.y, constructor.width, constructor.height

    constructor._scroll = {
        width = 1,
        x = x + width + 1,
        x2 = x + width + 2,
        y = y,
        y2 = y + height
    }

    setmetatable(constructor, self)
    self.__index = self

    return constructor
end

function Scroll:_drawLines()
    for i = 1, self.height do
        local item = self.lines[(self._position - 1) + i]

        if item == nil then
            break
        end

        gpu.set(self.x, (self.y + i) - 1, item)
    end
end

function Scroll:_drawScroll()
    local sliderHeight = math.floor(math.pow(self.height, 2) / #self.lines)
    local sliderPosition = math.floor(self._position * self.height / #self.lines)

    if self._position > 1 then
        gpu.fill(self.x + self.width - 4, self.y, 1, 1, "⌃")
    end

    if self._position ~= sliderHeight then
        gpu.fill(self.x + self.width - 5, self.y + self.height - 1, 1, 1, "⌄")
    end

    for i = 1, self.height do
        gpu.setBackground(0x123123)
        gpu.fill(self.width + 2, self.y + i - 1, 1, 1, " ")
        gpu.setBackground(0x000000)
    end

    gpu.setBackground(0x000000)
    gpu.fill(self.width + 2, self.y + sliderPosition, 1, sliderHeight, "█")
end

function Scroll:draw()
    -- Чистим поле компонента
    gpu.fill(self.x, self.y, self.width + 2, self.height, " ")

    self:_drawLines()
    self:_drawScroll()
end

function Scroll:offsetPosition(to)
    if to == -1 then
        if self._position > 1 then
            self._position = self._position - 1
            self:draw()
        end
    elseif to == 1 then
        if self._position < #self.lines - self.height + 1 then
            self._position = self._position + 1
            self:draw()
        end
    end
end

function Scroll:scrollTo(offset)
    if offset == 200 or offset == 1 then -- Стрелка вверх
        self:offsetPosition(-1)
    elseif offset == 208 or offset == -1 then -- Стрелка вниз
        self:offsetPosition(1)
    end
end

function Scroll:setPosition(x, y)
    local outOfHeight = y < self.y or y > self.y + self.height;
    -- local outOfWidth = x < self.x + self.width - 2 or x > self.x + self.width + 2

    if outOfHeight then
        return
    end

    y = math.floor((y - self.y) * self.height / #self.lines)

    if y == 0 then
        y = 1
    end

    self._position = y
    self:draw()
end

function Scroll:onEvent(event)
    local eventName = event[1]

    if eventName == "scroll" then
        self:scrollTo(event[5])
    elseif eventName == "key_down" then
        self:scrollTo(event[4])
    elseif eventName == "drag" or eventName == "touch" then
        self:setPosition(event[3], event[4])
    end
end

