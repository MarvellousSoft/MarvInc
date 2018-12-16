--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Going all the way is not always good"
-- Puzzle number
n = 2
test_count = 1

lines_on_terminal = 10
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- Objects
e = nil
-- name, draw background, image
o = {"obst", false, "wall_none"}

-- options: obst, dead

-- Objective
objective_text = "Just get to the red tile. Again."
function objective_checker(room)
    return room.bot.pos.x == 14 and room.bot.pos.y == 7
end

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oooooooo.oooooooooooo"..
            "oooooooo......ooooooo"..
            "oooooooo.oooooooooooo"..
            "oooooooo.oooooooooooo"..
            "oooooooo.oooooooooooo"..
            "oooooooo.oooooooooooo"..
            "ooooooooboooooooooooo"..
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
v = "black_floor"
r = "red_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "........w............"..
             "........vwvwvr......."..
             "........w............"..
             "........v............"..
             "........w............"..
             "........v............"..
             "........w............"..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."
