--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Firefighting"
-- Puzzle number
n = "D.4"
test_count = 1

lines_on_terminal = 20
memory_slots = 5

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'water'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oobkkkkkkkklllllllloo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
g = "green_tile"

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
             "..wwwwwwwwwwwwwwwww.."..
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

-- Objective
objective_text = "Extinguish all lava."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = ROWS * (i - 1) + j
            local o = room.grid_obj[j][i]
            if grid_obj:sub(p, p) == 'l' and o and o.tp == 'dead' then
                return false
            end
        end
    end
    return true
end

extra_info =
[[Water buckets can be dropped on the floor after being picked up.]]


function first_completed()
    _G.PopManager.new("I appreciate it",
        "Now I'll get back to the rest before that bitch sends me more!\n\nFergus",
        _G.CHR_CLR['fergus'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ... ",
            clr = _G.Color.blue()
        })
end
