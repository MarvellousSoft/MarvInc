--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Cleaner II"
n = "A.7"
test_count = 1

lines_on_terminal = 60
memory_slots = 6

-- Bot
bot = {'b', "WEST"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}

a = {"emitter", true, "emitter", "red", args = { t_args = {"ray", true, 0.05, "red"} }, dir="SOUTH"}

local dirs = {'east', 'west', 'north', 'south'}
for i = 1, 17 do
    local c = _G.string.char(_G.string.byte('b') + i)
    if c == 'n' then c = 'y' end
    local img = 'dead_body' .. random(1, 3)
    local color = _G.Color.new(random() * 256, 200, 150)
    local dir = dirs[random(1, 4)]
    env[c] = {'bucket', true, img, args = {content = 'empty', content_args = {color = color, img = 'dead_body_hair'}}, dir = dir}
end

x = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Objective
objective_text = "Throw all the bodies in the lava."

function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, _G.ROWS do
        for j = 1, _G.COLS do
            if room.grid_obj[j][i] and room.grid_obj[j][i].tp == 'bucket' then
                return false
            end
        end
    end

    return true
end


extra_info =[[
Bodies can block lasers. Obviously.
]]

grid_obj =   "x-aaaaaaaaaaaaaaaaa--"..
             "x...................."..
             "x...................c"..
             "x...................d"..
             "x...................e"..
             "x...................f"..
             "x...................g"..
             "x...................h"..
             "x...................i"..
             "x...................j"..
             "x..................bk"..
             "x...................l"..
             "x...................m"..
             "x...................y"..
             "x...................o"..
             "x...................p"..
             "x...................q"..
             "x...................r"..
             "x...................s"..
             "x...................."..
             "x--------------------"

-- Floor
w = "white_floor"
env[','] = "black_floor"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwww,www,w,www,wwwww"..
             "wwww,wwwww,wwwww,wwww"..
             "www,wwwww,w,wwwww,www"..
             "ww,wwwww,www,wwwww,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,www,wwwwwww,www,ww"..
             "www,w,wwwwwwwww,w,www"..
             "wwww,wwwwwwwwwww,wwww"..
             "www,w,wwwwwwwww,w,www"..
             "ww,www,wwwwwww,www,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,wwwww,www,wwwww,ww"..
             "www,wwwww,w,wwwww,www"..
             "wwww,wwwww,wwwww,wwww"..
             "wwwww,www,w,www,wwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"


function first_completed()
    _G.PopManager.new("Clean as a morgue",
        "I couldn't make it better myself.\nIf we get out of this mess in one piece, I'll buy you a bottle of Wharmpess and we put all of this havoc behind us, how about it?\n\n-Janine",
        _G.CHR_CLR['jen'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " it's a deal ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " thanks but nah ",
            clr = _G.Color.black()
        })
end
