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
objective_text = "Go to the green tile, stop, then look to the blue tile."
function objective_checker(room)
    return room.bot.pos.x == 14 and room.bot.pos.y == 16 and room.bot.r[2] == 1
end

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
