name = "Binary Painting"
-- Puzzle number
n = "A.4"

lines_on_terminal = 40
memory_slots = 20

-- Bot
bot = {'b', "SOUTH"}

local vec = {1, 0, 999, 512, 511, 12}
while #vec < 21 do
    _G.table.insert(vec, _G.love.math.random(2, 998))
end
for i = 1, #vec do
    local j = _G.love.math.random(i, #vec)
    vec[i], vec[j] = vec[j], vec[i]
    end
local function create_vec(x, y)
    return {vec[y]}
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint'}}
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
Each console on the left has a single number. Read it and write it on the tiles to the right of it.
- Painting a tile on the row i adds 2^(20 - i) to the number.
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
                    _G.StepManager.stop("Painted wrong place", "Tile on row " .. i .. " and column " .. j .. " shouldn't be painted. It isn't possible to write number " .. vec[i] .. " that way.", "Retry")
                    return false
                end
            end
        end
        _G.assert(x == 0)
    end
    return ok
end

extra_info = [[
All numbers are between 0 and 999.
- You may paint any number of tiles, as long as the number is correct.
- It can be shown that there's only one correct way to paint any number.]]

function first_completed()
    _G.PopManager.new("blah blah blah",
        "blah blah blah",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = "blah ",
            clr = _G.Color.blue()
        })
end