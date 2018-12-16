--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Cleanup on Aisle 5"
-- Puzzle number
n = "B.3"
-- TODO: All bodies are above or all bodies are below

lines_on_terminal = 12
memory_slots = 4

-- Bot
bot = {'b', "EAST"}

local env = _G.getfenv()
-- name, draw background, image
env['-'] = {"obst", false, "wall_none"}

local dirs = {'east', 'west', 'north', 'south'}
for i = 1, 20 do
    local c = _G.string.char(_G.string.byte('b') + i)
    if c == 'n' then c = 'x' end
    local img = 'dead_body' .. random(1, 3)
    local color = _G.Color.new(random() * 256, 200, 150)
    local dir = dirs[random(1, 4)]
    env[c] = {'bucket', true, img, args = {content = 'empty', content_args = {color = color, img = 'dead_body_hair'}}, dir = dir}
end

local floor

grid_obj =  "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "bcdefghijklmxopqrstuv"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"..
            "---------------------"

-- Floor
w = "white_floor"
A = 'blood_splat_1'
B = 'blood_splat_2'
C = 'blood_splat_3'
D = 'blood_splat_4'
env[','] = "black_floor"
z = 'green_tile'

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "wDwCwBAwBAwwDwwwCwBwA"..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

for i = 2, COLS do
    local y = random() <= .5 and 12 or 10
    local p = (y - 1) * COLS + i
    grid_obj = grid_obj:sub(1, p - 1) .. '.' .. grid_obj:sub(p + 1, ROWS * COLS)
    grid_floor = grid_floor:sub(1, p - 1) .. 'z' .. grid_floor:sub(p + 1, ROWS * COLS)
end

-- Objective
objective_text = "It is threat level Midnight! Clear the way! Move the bodies to the green tiles."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            if grid_floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'z' then
                local o = room.grid_obj[j][i]
                if not o or o.tp ~= 'bucket' then
                    return false
                end
            end
        end
    end
    return true
end

extra_info = [[
There is a tile directly above or below each body. They are generated randomly.
- Use walkc.]]

function first_completed()
    _G.PopManager.new("Situation status",
        "Never cleaner.",
        _G.CHR_CLR['paul'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " *you ponder your life choices* ",
            clr = _G.Color.blue()
        })
end
