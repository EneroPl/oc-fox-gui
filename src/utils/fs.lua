local fs = require("filesystem")

Filesystem = {}

Filesystem.toTable = function(path)
    local result = {}

    local file = io.open(path, "r")
    if not file then
        return nil
    end

    for line in file:lines() do
        local key, value = line:match("^(%w+)=(.+)$")
        if key and value then
            result[key] = value
        end
    end

    file:close()
    return result
end

Filesystem.toList = function(path)
    if not Filesystem.exist(path) then
        Filesystem.create(path)
    end

    local names = {}
    local file = io.open(path, "r")

    for line in file:lines() do
        table.insert(names, line)
    end

    file:close()
    return names
end

Filesystem.create = function(path, table)
    table = table or nil

    local file = io.open(path, "w")
    file:close()

    if table ~= nil then
        Filesystem.toFile(path, table)
    end
end

Filesystem.exist = function(path)
    if path == nil then
        return false
    end

    return fs.exists("/home/" .. path)
end

Filesystem.toFile = function(path, data)
    if not Filesystem.exist(path) then
        Filesystem.create(path)
    end

    local file = io.open(path, "w")

    for key, value in pairs(data) do
        file:write(string.format("%s=%s\n", key, tostring(value) or ""))
    end

    file:close() -- Закрываем файл
end

Filesystem.updateAsTable = function(path, payload)
    local data = Filesystem.toTable(path)

    for key, value in pairs(payload) do
        data[key] = value
    end

    Filesystem.toFile(path, data);
end

Filesystem.remove = function(path)
    local result, err = os.remove("/home/" .. path)

    if not result then
        return nil
    end
end
