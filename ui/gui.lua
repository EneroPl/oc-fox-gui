local component = require("component")
local unicode = require("unicode")
local gpu = component.gpu

GUI = {}

function GUI.text(x, y, text, color)
    color = color or 0xFFFFFF

    local oldColor = gpu.getForeground()

    gpu.setForeground(color)
    gpu.set(x, y, tostring(text))
    gpu.setForeground(oldColor)
end

function GUI.centerText(x, y, width, text, color)
    color = color or 0xFFFFFF

    local oldColor = gpu.getForeground()
    local textLength = unicode.len(text)

    if textLength >= width then
        return text
    end

    local padding = math.ceil((width - textLength) / 2)
    local leftPadding = math.floor(padding)
    local rightPadding = math.ceil(padding)

    gpu.setForeground(color)
    gpu.set(x, y, string.rep(" ", leftPadding) .. tostring(text) .. string.rep(" ", rightPadding))
    gpu.setForeground(oldColor)
end

function GUI.box(x, y, width, height)
    gpu.set(x, y, "┏")
    gpu.set(x + width, y, "┓")
    gpu.set(x, y + height, "┗")
    gpu.set(x + width, y + height, "┛")

    gpu.fill(x + 1, y, width - 1, 1, "━")
    gpu.fill(x + 1, y + height, width - 1, 1, "━")

    gpu.fill(x + width, y + 1, 1, height - 1, "┃")
    gpu.fill(x, y + 1, 1, height - 1, "┃")
end
