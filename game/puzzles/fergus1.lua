name = "Bucket Mover"
-- Puzzle number
n = "D.1"

lines_on_terminal = 100
memory_slots = 100

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}

local floor

-- Objective
objective_text = "Move the buckets to the green tiles."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            if floor:sub(ROWS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                local o = room.grid_obj[j][i]
                if not o or o.tp ~= 'bucket' then
                    return false
                end
            end
        end
    end
    return true
end

extra_info = "Extra registers and lines of code in case you need it."

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
            "ooo......b.....kkoooo"..
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
_G.getfenv()[','] = "green_tile"

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
             "...,,wwwwwwwwwwww...."..
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
floor = grid_floor

function first_completed()
    _G.PopManager.new("Congratulations",
        "Senior Tester Fergus will contact you at his earliest disposure.",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " hm.... ok ",
            clr = _G.Color.blue()
        })
end
