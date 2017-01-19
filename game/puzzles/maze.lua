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

grid_obj =  "bo.....o...........oo"..
            ".o.ooo.ooo.o.ooooo.oo"..
            "...o.o...o.o...o.o.oo"..
            ".ooo.ooo.o.ooo.o.o.oo"..
            "...o...o.o...o.o...oo"..
            "oo.o.o.o.ooooo.oooooo"..
            ".o.o.o.o.....o.....oo"..
            ".o.o.o.ooooo.ooooo.oo"..
            ".o.o.o.o...o.....o.oo"..
            ".o.o.o.o.o.ooooooo.oo"..
            "...o.o...o...o.....oo"..
            ".ooooooooooo.o.ooo.oo"..
            "...........o.o.o...oo"..
            "oooooooooo.o.o.o.oooo"..
            ".o.....o...o...o...oo"..
            ".o.ooo.o.ooooooooo.oo"..
            ".o.o.o...o...o.....oo"..
            ".o.o.ooooo.o.o.ooo.oo"..
            "...........o...o...oo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
g = "green_tile"

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
             "wwwwgwwwwwwwwwwwwwwww"..
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
