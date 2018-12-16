--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Home Improvement"
-- Puzzle number
n = "B.5"
-- TODO: Different drawing?
test_count = 1

lines_on_terminal = 40
memory_slots = 5

-- Bot
bot = {'b', "SOUTH"}

local final
local function create_vec()
    local v = {}
    local green = false
    local cur = 0
    for i = 2, ROWS - 1 do
        for j = 2, COLS - 1 do
            local gr = (final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == '.')
            if gr ~= green then
                _G.table.insert(v, cur)
                cur = 0
                green = gr
            end
            cur = cur + 1
        end
    end
    _G.table.insert(v, cur)
    return v
end

local black = _G.Color.black()
local green = _G.Color.green()

local function eq_color(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = black}}
d = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = green}}
h = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "west"}


grid_obj =  "dbhoooooooooooooooooo"..
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
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"
g = "black_floor"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
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
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

final =      "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwww..wwwwwwwww"..
             "wwwwwwwwww..wwwwwwwww"..
             "wwww.wwwww..wwwww.www"..
             "wwww..wwww..wwww..www"..
             "wwwww..www..www..wwww"..
             "wwwww...ww..ww...wwww"..
             "wwwwww..ww..ww..wwwww"..
             "wwwwww..ww..ww..wwwww"..
             "ww.wwww..w..w..www.ww"..
             "ww..www..w..w..ww..ww"..
             "wwww..ww......ww..www"..
             "wwwww.............www"..
             "wwwwwww........wwwwww"..
             "wwwwww...w..w...wwwww"..
             "wwwww..www..www..wwww"..
             "wwwwwwwwww..wwwwwwwww"..
             "wwwwwwwwww..wwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

-- Objective
objective_text = [[
You must paint the given tiles room, starting from tile (2, 2) till (20, 20).
- Read a number from the console, then ignore (don't paint) that number of tiles, from left to right.
- Read a number from the console, then paint that number of tiles in green, from left to right.
- Repeat that procedure until you navigated the whole room.
- When you paint or ignore a tile in the last column, you should continue painting or ignoring from the next line.]]
function objective_checker(room)
    local ok = true
    if room.color_floor[1][1] then
        _G.StepManager.stop("Painted wrong tile", "You weren't supposed to paint this tile. Your bot was sacrificed as punishment.")
        return false
    end
    for i = 2, ROWS - 1 do
        for j = 2, COLS - 1 do
            if final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == '.' then
                if not room.color_floor[j][i] then
                    ok = false
                elseif not eq_color(room.color_floor[j][i], green) then
                    _G.StepManager.stop("Painted wrong color", "Tile on row " .. i .. " and column " .. j .. " should be green. Your bot was sacrificed as punishment.")
                end
            elseif final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'w' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Painted wrong tile", "Tile on row " .. i .. " and column " .. j .. " shouldn't be painted. Your bot was sacrificed as punishment.")
                    return false
                end
            end
        end
    end
    return ok
end

extra_info = [[
The console will have exactly enough info to paint or ignore everything.
- All numbers are positive.
- You first paint (2, 2), then (2, 3), ..., then (2, 20), then (3, 2), and so on.
]]

function first_completed()
    _G.PopManager.new("You give good paintjobs",
        "No wonder Karl Franz didn't allow Paul to redecorate the labs.",
        _G.CHR_CLR['paul'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = "Quite unfortunate...",
            clr = _G.Color.blue()
        })
end
