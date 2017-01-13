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
    for i = 1, 20 do
        for j = 1, 20 do
            if floor:sub(20 * (i - 1) + j, 20 * (i - 1) + j) == ',' then
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

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooo......b.....kkooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "green_tile"

grid_floor = "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...,,wwwwwwwwwwww..."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
floor = grid_floor
