-- TODO: Components to local initialization
require("lib.ui.Button")
require("lib.ui.Progress")
require("lib.ui.Scroll")
require("lib.ui.Checkbox")
-- End

local expect = require("lib.expect")
local EventBus = require("lib.eventBus")

local COMPONENTS = {
    button = Button,
    progress = Progress,
    scroll = Scroll,
    checkbox = Checkbox
}

local event = EventBus:new()

Fox = {
    _break = false
}

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

function Fox:removeEventListeners()
    event:destroy()
end

function Fox:loop(fn, s)
    fn = fn or function()
    end

    expect(fn, "function")
    expect(s, "number")

    while true do
        if self._break then
            self:removeEventListeners();
            break
        end

        fn()

        os.sleep(s)
    end
end

function Fox:exit()
    self._break = true;
end
