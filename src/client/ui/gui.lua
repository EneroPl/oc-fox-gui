local component = require("component")
local term = require("term")
local gpu = component.gpu

GUI = {}
local SCREEN_WIDTH, SCREEN_HEIGHT = gpu.getResolution()

local COLOR = {
    green = 0x00AA00,
    red = 0xAA0000,
    black = 0x000000,
    white = 0xFFFFFF
}

local HALF_BLOCK = {
    TOP = "▀",
    BUTTOM = "▄",
    LEFT = "▌",
    RIGHT = "▐"
}

GUI.clear = function()
    gpu.fill(1, 1, SCREEN_WIDTH, SCREEN_HEIGHT, " ")
end

GUI.screenBox = function(color)
    color = color or COLOR.white

    gpu.setForeground(color)
    gpu.fill(1, 1, SCREEN_WIDTH, 1, HALF_BLOCK.TOP)
    gpu.fill(SCREEN_WIDTH, 1, 1, SCREEN_HEIGHT, HALF_BLOCK.RIGHT)
    gpu.fill(1, 1, 1, SCREEN_HEIGHT, HALF_BLOCK.LEFT)
    gpu.fill(1, SCREEN_HEIGHT, SCREEN_WIDTH, 1, HALF_BLOCK.BUTTOM)
end
