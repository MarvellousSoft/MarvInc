name = "Corridor Organizer"
-- Puzzle number
n = "undecided"

lines_on_terminal = 12
memory_slots = 4

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}

local floor

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "bkkkkkkkkkkkkkkkkkkkk"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
g = "green_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "wwwwwwwwwwwwwwwwwwwww"..
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

for i = 2, COLS do
    local y = _G.love.math.random() <= .5 and 12 or 10
    local p = (y - 1) * COLS + i
    grid_obj = grid_obj:sub(1, p - 1) .. '.' .. grid_obj:sub(p + 1, ROWS * COLS)
    grid_floor = grid_floor:sub(1, p - 1) .. 'g' .. grid_floor:sub(p + 1, ROWS * COLS)
end

-- Objective
--This obviously won't be buckets in the final game... I hope.
objective_text = "Move the buckets to the green tiles."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            if grid_floor:sub(20 * (i - 1) + j, 20 * (i - 1) + j) == 'g' then
                local o = room.grid_obj[j][i]
                if not o or o.tp ~= 'bucket' then
                    return false
                end
            end
        end
    end
    return true
end

extra_info = [[
There is a tile directly above or below each bucket. They are generated randomly.
- Remeber walkc.]]

function first_completed()
    _G.PopManager.new("blahblahblah",
        "blahblahblahblah",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " blah ",
            clr = _G.Color.blue()
        })
end
