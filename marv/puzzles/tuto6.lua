--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Basic Programming"
-- Puzzle number
n = 6
test_count = 1

lines_on_terminal = 20
memory_slots = 3

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = 'output', show_nums = 6}, dir = "west"}

local con

-- Objective
objective_text = "Write all numbers from 1 to 50 on the green console."
function objective_checker(room)
    if not con then
        for i = 1, ROWS do
            for j = 1, COLS do
                local o = room.grid_obj[i][j]
                if o and o.tp == "console" then
                    con = o
                end
            end
        end
    end
    ------
    if #con.inp == 0 then return false end
    for i = 1, #con.inp do
        if con.inp[i] ~= i then
            _G.StepManager.stop("Wrong output", "Expected " .. i .. " got " .. con.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #con.inp >= 50
end


extra_info =
  [[After you outputted the 50 numbers, the code will stop automatically, so there is no need to do it manually.
- You can use write [X] to write to the console the value stored in register X (in this case you have available registers #0, #1 and #2).]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooo.....coooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooo.ooooooooooo"..
            "ooooooooobooooooooooo"..
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
             ".........wwwwww......"..
             ".........w..........."..
             ".........w..........."..
             ".........w..........."..
             ".........w..........."..
             ".........w..........."..
             ".........w..........."..
             ".........w..........."..
             "....................."..
             "....................."..
             "....................."..
             "....................."
