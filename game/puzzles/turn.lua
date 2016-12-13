-- This is a test puzzle

name = "Changing Perspective"
-- Puzzle number
n = 2

lines_on_terminal = 10
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- Objects
e = nil
-- name, draw background, image
o = {"obst", false, "wall_none"}

-- options: obst, dead

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.pos.x == 14 and room.bot.pos.y == 16 and room.bot.r[2] == 1
    end, "Go to the green tile, stop, then look to the blue tile.",
    _G.LoreManager.turn_done}
}

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooooooooooooo.oooooo"..
            "ooooooooooooo.oooooo"..
            "ooooooooooooo.oooooo"..
            "ooooooooooooo.oooooo"..
            "ooooooooooooo.oooooo"..
            "oooooooooooo...ooooo"..
            "oooooo.........ooooo"..
            "oooooo.ooooo...ooooo"..
            "oooooo.ooooooooooooo"..
            "ooob...ooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
g = "green_tile"
t = "blue_tile"

grid_floor = "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             ".............t......"..
             ".............w......"..
             ".............w......"..
             ".............w......"..
             ".............w......"..
             "............www....."..
             "......wwwwwwwgw....."..
             "......w.....www....."..
             "......w............."..
             "...wwww............."..
             "...................."
