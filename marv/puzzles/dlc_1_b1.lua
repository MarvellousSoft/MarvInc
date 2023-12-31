--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "GPT Cleaner I"
n = "X.1"
test_count = 1

lines_on_terminal = 60
memory_slots = 10

-- Bot
bot = {'b', "WEST"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}

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
]]

grid_obj =   "x...................."..
             "x...................."..
             "x...................."..
             "x...................."..
             "x...................."..
             "x.........c.........."..
             "x........ccc........."..
             "x.......ccccc........"..
             "x......ccccccc......."..
             "x.....ccccccccc......"..
             "x....ccccccccccc....b"..
             "x.....ccccccccc......"..
             "x......ccccccc......."..
             "x.......ccccc........"..
             "x........ccc........."..
             "x.........c.........."..
             "x...................."..
             "x...................."..
             "x...................."..
             "x...................."..
             "x...................."

local final_grid = {}
for i = 1, _G.ROWS do
    for j = 1, _G.COLS do
        local pos = (i - 1) * _G.COLS + j
        if grid_obj:sub(pos, pos) == 'c' then
            local c = _G.string.char(_G.string.byte('b') + random(1, 17))
            if c == 'n' then c = 'y' end
            final_grid[pos] = c
        else
            final_grid[pos] = grid_obj:sub(pos, pos)
        end
    end
end
grid_obj = _G.table.concat(final_grid)


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
