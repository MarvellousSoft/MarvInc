--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Interior Design"
-- Puzzle number
n = "D.3"
test_count = 1

lines_on_terminal = 20
memory_slots = 5

local green = _G.Color.green()

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = green}}

local floor

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oocbk.............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooooooooooooooooooooo"..
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
             "....................."..
             "..wwwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...wwgwwwwwgwwwwww..."..
             "...wwg,www,gwwwwww..."..
             "...wwgw,w,wgwww,ww..."..
             "...wwgww,wwgwwwwww..."..
             "...wwgwwwwwgwww,ww..."..
             "...wwgwwwwwgwww,ww..."..
             "...wwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

floor = grid_floor

function on_start(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            if floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                room.color_floor[j][i] = green
            end
        end
    end
end

-- Objective
objective_text = "Complete the green painting of the Marvellous Inc. logo"
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            if floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'g' then
                if not room.color_floor[j][i] then
                    return false
                end
            elseif floor:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) ~= ',' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Wrong logo", "Painted a wrong tile! Your bot was sacrificed as punishment.")
                end
            end
        end
    end
    return true
end

extra_info =
[[You have few lines of code. Be smart.
- The bucket to your right is empty, you can refill it any number of times in the paint container to your left. To refill, use pickup on the container while holding the empty bucket.
- When you use drop and the bucket is full of paint, the floor in front of the bot will be painted and the bucket will stay in you inventory, now empty.]]

function first_completed()
    _G.PopManager.new("THANK YOU my friend",
        "You really are the bigger person\n\nFergus",
        _G.CHR_CLR['fergus'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ...glad to help ",
            clr = _G.Color.blue()
        })
end
