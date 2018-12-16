--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Hacking Forensics"
-- Puzzle number
n = "F.2"
-- TODO: Better cases
test_count = 10

lines_on_terminal = 40
memory_slots = 5

-- Bot
bot = {'b', "WEST"}

local function rnd(l, r) return random(l, r) end

local perm = {}
for i = 1, 21 do perm[i] = i end
for i = 1, 20 do
    local j = rnd(i, 21)
    perm[i], perm[j] = perm[j], perm[i]
end
local val = {}
val[perm[21]] = -1
for i = 1, 20 do
    val[perm[i]] = perm[i + 1]
end

local function create_in(i, j)
    return {val[j]}
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_in, show_nums = 0}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

-- console objects
local bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'console' and #o.out == 0 then
                bl = o
            end
        end
    end
end

-- Objective
objective_text = [[
An infection has spread through the Marvellous Inc. servers. It started on a single server, from there went to a second server, then to a third, and so on.
- Each green console has a single number, the console that was infected after it. The last console to be infected has the number -1. The number of the console is the row it is on.
- Write the number of the first green console that was infected to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if bl.inp[1] == perm[1] then
        return true
    else
        _G.StepManager.stop("Wrong output", "Incorrect console number. Your bot was sacrificed in the hope to fix this bad behaviour.")
        return false
    end
end

extra_info = [[
You have only 5 register position.
- Notice that you can only read the number from the console once.]]

grid_obj =  "c.....b.............."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c.........d.........."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."..
            "c...................."

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = ",,,,,,,,,,,,,,,,,,,,,"..
             ",wwwwwwwwwwwwwwwwwww,"..
             ",w,,,,,,,,,,,,,,,,,w,"..
             ",w,wwwwwwwwwwwwwww,w,"..
             ",w,w,,,,,,,,,,,,,w,w,"..
             ",w,w,wwwwwwwwwww,w,w,"..
             ",w,w,w,,,,,,,,,w,w,w,"..
             ",w,w,w,wwwwwww,w,w,w,"..
             ",w,w,w,w,,,,,w,w,w,w,"..
             ",w,w,w,w,www,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,www,w,w,w,w,"..
             ",w,w,w,w,,,,,w,w,w,w,"..
             ",w,w,w,wwwwwww,w,w,w,"..
             ",w,w,w,,,,,,,,,w,w,w,"..
             ",w,w,wwwwwwwwwww,w,w,"..
             ",w,w,,,,,,,,,,,,,w,w,"..
             ",w,wwwwwwwwwwwwwww,w,"..
             ",w,,,,,,,,,,,,,,,,,w,"..
             ",wwwwwwwwwwwwwwwwwww,"..
             ",,,,,,,,,,,,,,,,,,,,,"

function first_completed()
    _G.PopManager.new("The Great Firewall",
        "You have saved MarvInc from the invading hackers!",
        _G.CHR_CLR['franz'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " dishonor on the hackers cow! ",
            clr = _G.Color.blue()
        })
end
