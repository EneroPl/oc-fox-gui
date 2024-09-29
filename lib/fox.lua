-- TODO: Components to local initialization
require("lib.ui.Button")
require("lib.ui.Progress")
require("lib.ui.Scroll")
-- End

local EventBus = require("lib.eventBus")

local COMPONENTS = {
    button = Button,
    progress = Progress,
    scroll = Scroll
}

local event = EventBus:new()

Fox = {}
Fox.__index = Fox

function Fox:new(constructor)
    constructor = constructor or {}

    setmetatable(constructor, self)
    self.__index = self
    return constructor
end

function Fox:mount(componentName, props)
    local class = COMPONENTS[componentName]
    local component = class:new(props)

    if component._listeners then

        for _, eventName in pairs(component._listeners) do
            event:on(eventName, component)
        end
    end

    component:draw()

    return component
end

function Fox:addEvent(eventName, payload)
    event:on(eventName, payload)
end

function Fox:destroy()
    event:destroy()
end
