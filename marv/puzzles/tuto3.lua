--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Changing Perspective"
-- Puzzle number
n = 2
test_count = 1

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

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooo.ooooooo"..
            "ooooooooooooo.ooooooo"..
            "ooooooooooooo.ooooooo"..
            "ooooooooooooo.ooooooo"..
            "ooooooooooooo.ooooooo"..
            "oooooooooooo...oooooo"..
            "oooooo.........oooooo"..
            "oooooo.ooooo...oooooo"..
            "oooooo.oooooooooooooo"..
            "ooob...oooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
g = "green_tile"
t = "blue_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             ".............t......."..
             ".............w......."..
             ".............w......."..
             ".............w......."..
             ".............w......."..
             "............www......"..
             "......wwwwwwwgw......"..
             "......w.....www......"..
             "......w.............."..
             "...wwww.............."..
             "....................."..
             "....................."
