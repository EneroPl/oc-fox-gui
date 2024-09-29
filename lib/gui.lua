local component = require("component")
local unicode = require("unicode")
local term = require("term")

local gpu = component.gpu
local GUI = {}

local COLORS = {
    white = 0xFFFFFF,
    black = 0x000000,
    red = 0xFF0000
}

function GUI._initColor(color, default)
    return COLORS[color] or color or default
end

function GUI._wrapFn(payload)
    payload.color = GUI._initColor(payload.color, COLORS.white)
    payload.bgColor = GUI._initColor(payload.bgColor, COLORS.black)

    local oldColor, oldBgColor = table.unpack({gpu.getForeground(), gpu.getBackground()})

    gpu.setForeground(payload.color)
    gpu.setBackground(payload.bgColor)

    payload.callback()

    gpu.setForeground(oldColor)
    gpu.setBackground(oldBgColor)
end

function GUI.clear()
    term.clear()
end

function GUI.box(x, y, width, height, color, bgColor)
    GUI._wrapFn({
        color = color,
        bgColor = bgColor,
        callback = function()
            gpu.set(x, y, "┏")
            gpu.set(x + width, y, "┓")
            gpu.set(x, y + height, "┗")
            gpu.set(x + width, y + height, "┛")

            gpu.fill(x + 1, y, width - 1, 1, "━")
            gpu.fill(x + 1, y + height, width - 1, 1, "━")

            gpu.fill(x + width, y + 1, 1, height - 1, "┃")
            gpu.fill(x, y + 1, 1, height - 1, "┃")
        end
    })
end

function GUI.text(x, y, text, color, bgColor)
    GUI._wrapFn({
        color = color,
        bgColor = bgColor,
        callback = function()
            if type(text) == 'table' then
                local lineIndex = y

                for _, line in pairs(text) do
                    gpu.set(x, lineIndex, tostring(line))
                    lineIndex = lineIndex + 1
                end
            else
                gpu.set(x, y, tostring(text))
            end
        end
    })
end

function GUI.centerText(x, y, width, text, color, bgColor)
    GUI._wrapFn({
        color = color,
        bgColor = bgColor,
        callback = function()
            local textLength = unicode.len(text)

            if textLength >= width then
                return text
            end

            local padding = math.ceil((width - textLength) / 2)
            local leftPadding = math.floor(padding)
            local rightPadding = math.ceil(padding)

            gpu.set(x, y, string.rep(" ", leftPadding) .. tostring(text) .. string.rep(" ", rightPadding))
        end
    })
end

function GUI.fill(x, y, width, height, text, bgColor)
    GUI._wrapFn({
        bgColor = bgColor,
        callback = function()
            gpu.fill(x, y, width, height, text)
        end
    })
end

function GUI.len(text)
    return unicode.len(text)
end

return GUI
