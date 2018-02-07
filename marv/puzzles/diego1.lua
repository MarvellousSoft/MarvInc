--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Chessmat Painter"
-- Puzzle number
n = "D.1"

lines_on_terminal = 25
memory_slots = 5

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint'}}

local floor

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooocbk...........oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "oooo.............oooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"
g = "black_floor"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....,w,w,w,w,w,w,...."..
             "....w,w,w,w,w,w,w...."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

floor = grid_floor

-- Objective
objective_text = "Paint all dark tiles, and none of the white."
function objective_checker(room)
    local good = true
    for i = 1, ROWS do
        for j = 1, COLS do
            if floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                if not room.color_floor[j][i] then
                    good = false
                end
            elseif floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'w' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Wrong painting", "Painted a wrong tile! Your bot was sacrificed as punishment.")
                    return false
                end
            end
        end
    end
    return good
end

function first_completed()
    _G.PopManager.new("great, bro. don’t get cocky.",
        [[i will continue my search. ill let you know if i find anything.

        --master broda vega]],
        _G.CHR_CLR['diego'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I got a bad feeling about this ",
            clr = _G.Color.blue()
        })
end
