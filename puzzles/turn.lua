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
        return room.bot.pos.x == 14 and room.bot.pos.y == 15 and room.bor.r[2] == 0
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
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooo.ooooo"..
            "oooooooooooooo.ooooo"..
            "ooooooooooooo...oooo"..
            "ooooooo.........oooo"..
            "ooooooo.ooooo...oooo"..
            "ooooooo.oooooooooooo"..
            "ooob....oooooooooooo"..
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
             "...................."..
             "...................."..
             "...................."..
             ".............t......"..
             ".............w......"..
             "............www....."..
             "......wwwwwwwgw....."..
             "......w.....www....."..
             "......w............."..
             "...wwww............."..
             "...................."
