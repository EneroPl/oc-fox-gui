require("utils.fs")

Reactive = {
    path = nil,
    default = {}
}
Reactive.__index = Reactive

function Reactive:new(constructor)
    constructor = constructor or {}

    setmetatable(constructor, self)
    self.__index = self

    if Filesystem.exist(constructor.path) then
        Filesystem.remove(constructor.path)
    end

    Filesystem.create(constructor.path, constructor.default)

    return constructor
end

function Reactive:get()
    return Filesystem.toTable(self.path)
end

function Reactive:set(table)
    Filesystem.toFile(self.path, table)
end

function Reactive:update(table)
    Filesystem.updateAsTable(self.path, table)
end

function Reactive:reset()
    Filesystem.remove(self.path)
    Filesystem.create(self.path, self.default)
end

function Reactive:clear()
    Filesystem.remove(self.path)
    Filesystem.create(self.path)
end
