name = "Maze Sprinter"
-- Puzzle number
n = "undecided"

lines_on_terminal = 30
memory_slots = 6

-- Bot
bot = {'b', "WEST"}


-- name, draw background, image
o = {"obst", false, "wall_none"}

-- Objective
objective_text = [[Get to the green tile.]]
function objective_checker(room)
    return room.bot.pos.x == 5 and room.bot.pos.y == 13
end


extra_info = [[
Be smart. You can solve this so it works on any maze.]]

grid_obj =  ".........o..........."..
            ".ooooo.o.o.ooooooooo."..
            ".o.o...o...o.......o."..
            ".o.o.ooooooo.ooooo.o."..
            ".o.o.o.....o.....o.o."..
            ".o.o.o.ooo.ooo.o.o.o."..
            ".o.o.....o...o.o.o.o."..
            ".o.ooooooo.o.ooo.ooo."..
            ".....o...o.o...o....."..
            "oooo.o.o.ooooo.oooooo"..
            ".....o.o.....o......."..
            ".ooooo.ooooo.o.ooooo."..
            ".o...o.o...o.o.o...o."..
            ".o.ooo.o.o.o.o.ooo.o."..
            "...o...o.o.o.o.....o."..
            ".ooo.ooo.o.o.ooooooo."..
            ".o...o...o.o...o...o."..
            "oo.ooo.ooo.ooo.o.o.o."..
            "...o...o.o...o...o.o."..
            ".ooooo.o.ooo.ooooo.o."..
            "....bo.....o........."

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
