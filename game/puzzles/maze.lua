name = "Maze Sprinter"
-- Puzzle number
n = "undecided"

lines_on_terminal = 30
memory_slots = 6

-- Bot
bot = {'b', "SOUTH"}


-- name, draw background, image
o = {"obst", false, "wall_none"}

-- Objective
objective_text = [[Get to the green tile.]]
function objective_checker(room)
    return room.bot.pos.x == 5 and room.bot.pos.y == 11
end


extra_info = [[
Be smart. You can solve this so it works on any maze.]]

grid_obj =  "bo.....o...........o"..
            ".o.ooo.ooo.o.ooooo.o"..
            "...o.o...o.o...o.o.o"..
            ".ooo.ooo.o.ooo.o.o.o"..
            "...o...o.o...o.o...o"..
            "oo.o.o.o.ooooo.ooooo"..
            ".o.o.o.o.....o.....o"..
            ".o.o.o.ooooo.ooooo.o"..
            ".o.o.o.o...o.....o.o"..
            ".o.o.o.o.o.ooooooo.o"..
            "...o.o...o...o.....o"..
            ".ooooooooooo.o.ooo.o"..
            "...........o.o.o...o"..
            "oooooooooo.o.o.o.ooo"..
            ".o.....o...o...o...o"..
            ".o.ooo.o.ooooooooo.o"..
            ".o.o.o...o...o.....o"..
            ".o.o.ooooo.o.o.ooo.o"..
            "...........o...o...o"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
g = "green_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwgwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"


function first_completed()
    _G.PopManager.new("lalala",
        "lalalallala",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " lalala ",
            clr = _G.Color.blue()
        })
end
