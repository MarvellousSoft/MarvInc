--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Cleaner I"
-- Puzzle number
n = "A.6"
-- TODO: Different drawing?
test_count = 1

lines_on_terminal = 20
memory_slots = 5

-- Bot
bot = {'b', "SOUTH"}

local final
local function create_vec()
    local final = grid_floor
    local tmp = {}
    for i = 1, ROWS do
        for j = 1, COLS do
            if final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) ~= '.' then
                _G.table.insert(tmp, {i, j})
            end
        end
    end
    local v = {}
    for i = 1, #tmp do
        local j = random(i, #tmp)
        tmp[i], tmp[j] = tmp[j], tmp[i]
        _G.table.insert(v, tmp[i][1])
        _G.table.insert(v, tmp[i][2])
    end
    return v
end

local green = _G.Color.white()
-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty', content_color = _G.Color.black()}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = green}}
h = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "west"}


grid_obj =  "cbhoooooooooooooooooo"..
            "ok..................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "ooooooooooooooooooooo"

-- Floor
_G.getfenv()['.'] = "white_floor"
_G.getfenv()['A'] = "blood_splat_1"
_G.getfenv()['B'] = "blood_splat_2"
_G.getfenv()['C'] = "blood_splat_3"
_G.getfenv()['D'] = "blood_splat_4"
g = "black_floor"

final      = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
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

grid_floor = "....................."..
             ".ABBDCBD..........DC."..
             "..A....CBD.......C..."..
             "...C.AD...C.........."..
             "....A.....B.........."..
             "....B.....A.........."..
             "....C.....DC........."..
             "....B..B..D.B........"..
             "....A..C..B..A......."..
             "....C...A.....A......"..
             "...B....BA..........."..
             "...A............B...."..
             "......B...A.......AC."..
             ".A.B..DBDAC...A...BD."..
             "............B........"..
             "...B......B.........."..
             "...ACB..D............"..
             "....................."..
             ".................A..."..
             ".AB................B."..
             "....................."

-- Objective
objective_text = [[
The floor is... dirty. The coordinate of the dirty tiles are in the green console. For each pair of numbers (i, j) on the console, clean tile on row i and column j, by painting it using the bucket and the bleach in the container.]]
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = COLS * (i - 1) + j
            if grid_floor:sub(p, p) ~= '.' then
                if room.color_floor[j][i] then
                    room.color_floor[j][i] = nil
                    grid_floor = grid_floor:sub(1, p - 1) .. '.' .. grid_floor:sub(p + 1, #grid_floor)
                    room.grid_floor[j][i] = 'white_floor'
                end
            elseif grid_floor:sub(p, p) == '.' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Cleaned wrong tile", "Tile on row " .. i .. " and column " .. j .. " shouldn't be cleaned. Your bot was sacrificed as punishment.")
                    return false
                end
            end
        end
    end
    return grid_floor == final
end

extra_info = [[
Don't waste any bleach.
- All coordinates are between 2 and 20.
- Go fuck yourself.]]

function first_completed()
    _G.PopManager.new("That looks clean",
        "You shouldn't expect a \"thank you\" from Janine anytime soon",
        _G.CHR_CLR['jen'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ...so are we ignoring the blood? ",
            clr = _G.Color.blue()
        })
end
