--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Advanced Bucket Mover"
-- Puzzle number
n = "D.2"
test_count = 1

lines_on_terminal = 50
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'water'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

local floor

-- Objective
objective_text =
[[Step on the red tile.
- Then move the buckets to the green tiles.
- Then step on the blue tile three times.]]

local prog
function on_start(room) prog = 0 end
function objective_checker(room)
    if prog == 0 and room.bot.pos.x == 18 and room.bot.pos.y == 7 then
        prog = 1
    end
    if prog == 1 then
        local b1, b2, b3 = room.grid_obj[9][13], room.grid_obj[10][13], room.grid_obj[11][13]
        if b1 and b2 and b3 and b1.tp == b2.tp and b2.tp == b3.tp and b1.tp == 'bucket' then
            prog = 2
        end
    end
    if (prog == 2 or prog == 4 or prog == 6) and room.bot.pos.x == 17 and room.bot.pos.y == 11 then
        prog = prog + 1
    end
    if (prog == 3 or prog == 5) and (room.bot.pos.x ~= 17 or room.bot.pos.y ~= 11) then
        prog = prog + 1
    end
    return prog == 7
end

extra_info = nil

grid_obj =  "b.....o.............o"..
            "ooooo.o.ooooooooooo.o"..
            "ooooo.o.o........oo.o"..
            "ooooo.....oooooo.oo.o"..
            "ooooooo.oooooooo.oo.o"..
            "ooooooo.oooooooo.oo.o"..
            "ooooooo.oooooooo....o"..
            "ooooooo.ooooooooooooo"..
            "ooooooo.ooooooooooooo"..
            "ooooooo.kkklooolllooo"..
            "ooooooo....loool.looo"..
            "ooooooo....loool.looo"..
            "ooooooo....loooo.oooo"..
            "ooooooo.oooooooo.oooo"..
            "ooooooo.oloooooo.oooo"..
            "ooooooo.o....loo.oooo"..
            "ooooooo...lo..lo.oooo"..
            "ooooooooooool....looo"..
            "ooooooooooooolooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"
g = "green_tile"
b = "blue_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwrwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwbwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwgggwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

floor = grid_floor

function first_completed()
    _G.PopManager.new("Well done",
        "I'm sure this was a real challenge for you.\n\nFergus Gerhard Jacobsen",
        _G.CHR_CLR['fergus'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ... ",
            clr = _G.Color.blue()
        })
end
