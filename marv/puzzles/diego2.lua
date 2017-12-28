--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Dodge the lasers"
n = "D.2"

lines_on_terminal=30
memory_slots=4

-- Bot
bot = {'b', "EAST"}

o = {"obst", false, "wall_none"}

-- Green block
h = {"emitter", true, "emitter", "green", args= {
    x1 = 15, y1 = 10,
    x2 = 3, y2 = 10,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="WEST"}

grid_obj =   "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooo~~~~~~~~~~~~~~~~oo"..
             "oo~~~~~~~~~~~~~~~~~oo"..
             "oo~~~~~~~~~~~~~~~~~oo"..
             "oo~~~~~~~~~~~~~~~~~oo"..
             "oooooooooooooooooo~oo"..
             "oooooooooooooooooo~oo"..
             "oooooooooooooooooo~oo"..
             "oooooooooooooooooo~oo"..
             "ooo~~~~~~~~~~~~~~~~oo"..
             "oo~~~~~~~~~~~~~~~~~oo"..
             "oob~~~~~~~~~~~~~~~~oo"..
             "oo~~~~~~~~~~~~~~~~~oo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"

local function set(i, j, c)
    local p = COLS * (i - 1) + j
    grid_obj = grid_obj:sub(1, p - 1) .. c .. grid_obj:sub(p + 1, ROWS * COLS)
end

local em1, em2 = {}, {}

for i = 1, COLS - 6 do
    em1[i] = {'emitter', true, 'emitter', 'green', args = {
        x1 = i + 3,
        x2 = i + 3,
        y1 = 14,
        y2 = 16,
        t_args = {'ray', true, 0.05, 'green'}
    }, dir = 'SOUTH', x = i + 3, y = 13, on = true}
    _G.getfenv()[_G.string.char(i + 31)] = em1[i]
    set(em1[i].y, em1[i].x, _G.string.char(i + 31))

    em2[i] = {'emitter', true, 'emitter', 'red', args = {
        x1 = i + 3,
        x2 = i + 3,
        y1 = 6,
        y2 = 8,
        t_args = {'ray', true, 0.05, 'red'}
    }, dir = 'SOUTH', x = i + 3, y = 5}
    _G.getfenv()[_G.string.char(i + 31 + COLS - 6)] = em2[i]
    set(em2[i].y, em2[i].x, _G.string.char(i + 31 + COLS - 6))
end

local red = COLS - 5
function onTurn(x)
    local g = _G.ROOM.grid_obj

    red = red - 1
    if x % 5 == 4 then red = red + 2 end
    if x % 5 == 0 then red = red + 1 end
    if red == 0 then red = COLS - 6 end
    if red == COLS - 5 then red = 1 end

    em1[((x - 1) % (COLS - 6)) + 1].on = false
    em1[((x - 1 + COLS - 7) % (COLS - 6)) + 1].on = true
    for i = 1, COLS - 6 do
        if em1[i].on then
            g[em1[i].x][em1[i].y]:wakeup()
        else
            g[em1[i].x][em1[i].y]:sleep()
        end
        if i ~= red then
            g[em2[i].x][em2[i].y]:wakeup()
        else
            g[em2[i].x][em2[i].y]:sleep()
        end
    end
end

-- Objective
objective_text = "Reach any green tile, avoiding the lasers."

function objective_checker(room)
    return room.bot.pos.x == 3 and room.bot.pos.y >= 6 and room.bot.pos.y <= 8
end

extra_info =[[
Before coding, watch the lasers to figure out their patterns.
- To do that, you can use "lab: jmp lab".
- Instructions like jmp also take 1 turn.
]]

-- Floor
w = "white_floor"
v = "black_floor"
x = "red_tile"
g = "green_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwgwwwwwwwwwwwwwwwwww"..
             "wwgwwwwwwwwwwwwwwwwww"..
             "wwgwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"


function first_completed()
    _G.PopManager.new("this will do bro",
        [[i think i can get pass the security system for the confidential files.

        i will expose marvinc for what they rlly are and get to the bottom of this.

        dont tell anyone about this bro, im counting on you

        --investigator bro-vega]],
        _G.CHR_CLR['diego'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ...okay? ",
            clr = _G.Color.black()
        })
end
