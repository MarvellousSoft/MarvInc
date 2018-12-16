--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Advanced Firefighting"
n = "B.4"
test_count = 1

lines_on_terminal = 30
memory_slots = 7

-- Bot
bot = {'b', 'WEST'}

-- name, draw background, image
o = {'obst', false, 'wall_none'}
k = {'bucket', true, 'bucket', args = {content = 'water'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

local objs

objective_text = "Get this fire sorted."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = ROWS * (i - 1) + j
            local o = room.grid_obj[j][i]
            if objs:sub(p, p) == 'l' and o and o.tp == 'dead' then
                return false
            end
        end
    end
    return true
end

extra_info = nil

grid_obj =  "ooooooooooooooooooooo"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "oooooooooooooooooolko"..
            "okkkkkkkkkblllllllllo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooklo"..
            "ooooooooooooooooooooo"
objs = grid_obj

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "grey_tile"
g = "grey_tile"


grid_floor = "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             "w,w,w,w,w,w,w,w,w,w,w"

function first_completed()
    _G.PopManager.new("Situation status",
        "The fire has been extinguished. Paul can get his interns to fix the reactor.",
        _G.CHR_CLR['paul'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " poor fellas ",
            clr = _G.Color.blue()
        })
end
