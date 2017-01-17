name = "Interior Design"
-- Puzzle number
n = "D.3"

lines_on_terminal = 20
memory_slots = 5

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}

local floor

-- Objective
--This obviously won't be buckets in the final game... I hope.
objective_text = "Complete the buckets on the Marvellous logo"
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

extra_info = "You have 20 lines of code"

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooobkkkkkkkkkkkk.ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..k...k.......ooo"..
            "ooo...k.k.....k..ooo"..
            "ooo....k.........ooo"..
            "ooo...........k..ooo"..
            "ooo...........k..ooo"..
            "ooo..............ooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...wwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwww..."..
             "...w,wwwww,wwwwww..."..
             "...w,,www,,wwwwww..."..
             "...w,w,w,w,www,ww..."..
             "...w,ww,ww,wwwwww..."..
             "...w,wwwww,www,ww..."..
             "...w,wwwww,www,ww..."..
             "...wwwwwwwwwwwwww..."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
floor = grid_floor

function first_completed()
    _G.PopManager.new("THANK YOU my friend",
        "You really are the bigger person",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " Glad to help ",
            clr = _G.Color.blue()
        })
end
