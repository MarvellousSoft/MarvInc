--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

-- This is a test puzzle

name = "DO YOU EVEN LIFT?"
-- Puzzle number
n = 4
test_count = 1

lines_on_terminal = 10
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}

-- Objective
objective_text = "Get tired. Walk 200 steps."

function objective_checker(room)
    return room.bot.steps >= 200
end

extra_info = [[The experiment ends as soon as the objective requirements are completed.
- You can use the Fast (>>) or SuperFast (>>>) speed buttons to make the turns go faster.
- Remember you can write commands in the same line you define a label.]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooobooooooooooo"..
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
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             ".........w..........."..
             ".........v..........."..
             "....................."..
             "....................."..
             "....................."
