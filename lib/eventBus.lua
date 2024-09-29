local event = require("event")

-- Шина событий
local EventBus = {
    -- onEvent - функция, которая должна быть в каждой
    -- таблице для выполнения вызова функции при событии
    -- либо в виде метода класса, либо в виде функции
    listeners = {}
}

EventBus.__index = EventBus

function EventBus:new(constructor)
    constructor = constructor or {}

    setmetatable(constructor, self)
    self.__index = self
    return constructor
end

function EventBus.emit(eventName, arg1, arg2, arg3, arg4)
    for _, item in pairs(EventBus.listeners[eventName]) do
        local ok = pcall(function()
            item:onEvent(eventName, arg1, arg2, arg3, arg4)
        end)

        if not ok then
            pcall(function()
                item.onEvent(eventName, arg1, arg2, arg3, arg4)
            end)
        end
    end
end

function EventBus:on(eventName, item)
    if not self.listeners[eventName] or self.listeners[eventName] == nil then
        self.listeners[eventName] = {item}
        event.listen(eventName, EventBus.emit)

        return;
    end

    local length = #self.listeners[eventName] + 1;

    self.listeners[eventName][length] = item
end

-- TODO: Добавить возможность удалять событие конкретного компонента,
-- а не всего события
function EventBus:off(eventName, callback)
    if not self.listeners[eventName] then
        return
    end

    event.ignore(eventName, EventBus.emit)
    self.listeners[eventName] = nil
end

function EventBus:destroy()
    for eventName in pairs(self.listeners) do
        self:off(eventName, EventBus.emit)
    end

    self.listeners = {}
end

return EventBus
