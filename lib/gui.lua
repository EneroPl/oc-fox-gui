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

local DEFAULT_SIDES_ROUNDED = {
    TOP_LEFT = "╭",
    TOP_RIGHT = "╮",
    BOTTOM_LEFT = "╰",
    BOTTOM_RIGHT = "╯",
    LEFT = "│",
    TOP = "─",
    RIGHT = "│",
    BOTTOM = "─"
}

local DEFAULT_SIDES = {
    TOP_LEFT = "┏",
    TOP_RIGHT = "┓",
    BOTTOM_LEFT = "┗",
    BOTTOM_RIGHT = "┛",
    LEFT = "┃",
    TOP = "━",
    RIGHT = "┃",
    BOTTOM = "━"
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

function GUI.isClickInside(clickX, clickY, x, y, x2, y2)
    local isInsideX = clickX >= x and clickX <= x2;
    local isInsideY = clickY >= y and clickY <= y2;

    return isInsideX and isInsideY;
end

function GUI.box(x, y, width, height, color, bgColor, rounded)
    local sides = DEFAULT_SIDES

    if rounded then
        sides = DEFAULT_SIDES_ROUNDED
    end

    GUI._wrapFn({
        color = color,
        bgColor = bgColor,
        callback = function()
            gpu.set(x, y, sides.TOP_LEFT)
            gpu.set(x + width, y, sides.TOP_RIGHT)
            gpu.set(x, y + height, sides.BOTTOM_LEFT)
            gpu.set(x + width, y + height, sides.BOTTOM_RIGHT)

            gpu.fill(x + 1, y, width - 1, 1, sides.TOP)
            gpu.fill(x + 1, y + height, width - 1, 1, sides.BOTTOM)

            gpu.fill(x + width, y + 1, 1, height - 1, sides.LEFT)
            gpu.fill(x, y + 1, 1, height - 1, sides.RIGHT)
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
