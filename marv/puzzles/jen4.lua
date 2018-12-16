--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Binary Painting"
-- Puzzle number
n = "A.4"
-- TOO LONG
test_count = 2

lines_on_terminal = 40
memory_slots = 20

-- Bot
bot = {'b', "SOUTH"}

local vec = {1, 0, 999, 512, 511, 12}
while #vec < 21 do
    _G.table.insert(vec, random(2, 998))
end
for i = 1, #vec do
    local j = random(i, #vec)
    vec[i], vec[j] = vec[j], vec[i]
    end
local function create_vec(x, y)
    return {vec[y]}
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = _G.Color.new(272 * 255 / 360, .65 * 255, .54 * 255)}}
h = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "east"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}

grid_obj =  "oooooooohb..........c"..
            "oooooooohk..........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"..
            "ooooooooh...........c"

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

-- Objective
objective_text = [[
Each console on the left has a single number. Read the number and write it in binary on the tiles to the right in the same row.
- Painting a tile on the column i adds 2^(20 - i) to the number.
- That means painting the rightmost tile (next to the paint container) adds 1 to the number, the one to the left adds 2, the next 4, and so on.]]

function objective_checker(room)
    local p2 = {[0] = 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024}
    local ok = true
    for i = 1, ROWS do
        local x = vec[i]
        for j = COLS - 11, COLS - 1 do
            if x >= p2[COLS - 1 - j] then
                x = x - p2[COLS - 1 - j]
                if not room.color_floor[j][i] then
                    ok = false
                end
            else
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Painted wrong place", "Tile on row " .. i .. " and column " .. j .. " shouldn't be painted. It isn't possible to write number " .. vec[i] .. " that way. Your bot was sacrificed as punishment.")
                    return false
                end
            end
        end
        _G.assert(x == 0)
    end
    if ok and not _G.LoreManager.puzzle_done.jen4_fast then
        local ic = _G.StepManager.ic
        if ic <= 5000 then
            _G.LoreManager.puzzle_done.jen4_fast = true
        end
    end
    return ok
end

extra_info = [[
All numbers are between 0 and 999.
- It can be shown that there's only one correct way to paint any number.
- There is a very slow way to do this and a fast way. Both will work, but you may need to wait a lot for the former to run, since the numbers are large, so we recommend the latter :).]]

function first_completed()
    _G.PopManager.new("Great work CS2",
        [[
Actually I just assumed you did a great work.
I'm busy looking at a grumpy cat pic.

It's hilarious.

I will analyse your work after I'm done laughing.

-Janine]],
        _G.CHR_CLR['jen'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ... ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " 01100011 01100001 01110100 ",
            clr = _G.Color.red()
        })
end
