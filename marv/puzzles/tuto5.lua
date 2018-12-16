--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Basic Firefighting"
-- Puzzle number
n = 5
test_count = 1

lines_on_terminal = 20
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'water'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Objective
objective_text = "Get to the red tile. Extinguish all the lava in the way using the giant buckets. Obviously."
function objective_checker(room)
    return room.bot.pos.x == 9 and room.bot.pos.y == 14
end

extra_info =
[[To extinguish lava, water isn't enough. That's why when you drop a water bucket into lava, the robot throws the bucket with it. It's science.
- If the robot tries to pick something that isn't an object, drops something in a blocked space or drops something with an empty inventory, the simulation will throw an error.
- The robot can't walk on a tile occupied by a bucket. They are just too big.]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooookoooooooooooooo"..
            "oooook.l...kooooooooo"..
            "oooooo.oooolooooooooo"..
            "ooooooboooolooooooooo"..
            "oooooooo....ooooooooo"..
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
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "......w.............."..
             ".....wwwwwww........."..
             "......w....w........."..
             "......w....w........."..
             "........rwww........."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."
