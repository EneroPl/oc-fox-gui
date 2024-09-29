-- TODO: Расширить функцию для таблиц, чтобы гавной там не пихало всё
local function expect(value, ...)
    local types = {...}
    local valueType = type(value)
    local isValidType = false

    -- Проверяем, соответствует ли тип переменной одному из указанных типов
    for _, expectedType in ipairs(types) do
        if valueType == expectedType then
            isValidType = true
            break
        end
    end

    -- Если тип не соответствует, выводим ошибку
    if not isValidType then
        error(string.format("TypeError: Expected type(s): %s, but got type: %s", table.concat(types, ", "), valueType))
    end
end

return expect
