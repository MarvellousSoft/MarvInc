--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "DLC II"
n = "X.2"
test_count = 3

lines_on_terminal = 60
memory_slots = 10

-- Bot
bot = {'b', "WEST"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}

local dirs = {'east', 'west', 'north', 'south'}

local function char_for(i)
    local c = _G.string.char(_G.string.byte('b') + i)
    if c == 'n' then c = 'y' end
    return c
end

for i = 1, 17 do
    local c = char_for(i)
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
Bodies are all over the place, but never next to lava.
- Look at the test cases.
]]

grid_obj =   "xxxxxxxxxxxxxxxxxxxxx"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x..................bx"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "x...................x"..
             "xxxxxxxxxxxxxxxxxxxxx"

-- Increase chance of empty col
local empty_col = random(0, 20)
for i = 3, _G.COLS - 2 do
    local bodies_n = _G.math.min(random(0, 12), random(0, 15))
    local bodies = {}
    for j = 1, 17 do
        bodies[j] = j <= bodies_n
    end
    -- Randomize bodies
    for j = 17, 2, -1 do
        local k = random(j)
        bodies[j], bodies[k] = bodies[k], bodies[j]
    end
    -- Force bodies at edges to make code simpler
    if i == 3 or i == _G.COLS - 2 then
        bodies[17] = true
        bodies[1] = true
    end
    for j = 1, 17 do
        if bodies[j] and j ~= empty_col then
            local pos = (i - 1) * _G.COLS + j + 2
            grid_obj = grid_obj:sub(1, pos - 1) .. char_for(random(17)) .. grid_obj:sub(pos + 1)
        end
    end
end


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
