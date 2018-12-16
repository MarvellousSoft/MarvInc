--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Simple Sort"
-- Puzzle number
n = "C.3B"

lines_on_terminal = 35
memory_slots = 12

-- Bot
bot = {'b', "NORTH"}

local vs = {}

-- Objective
objective_text = "Read 6 sequences of 3 numbers from the green console, then write them to the 6 blue consoles, from left to right. You must sort these sequences."
function objective_checker(room)
    local g = room.grid_obj
    local cg = g[3][6]
    local cbs = {}
    local all = true
    for i = 1, 6 do
        cbs[i] = g[4 + 2 * i][5]
        if #cbs[i].inp > 3 then
            _G.StepManager.stop("Wrong output", "More than 3 numbers in blue console " .. i..". Your bot was sacrificed as punishment.")
            return false
        end
        if #cbs[i].inp < 3 then all = false end
        for j = 1, 3 do
            if cbs[i].inp[j] and cbs[i].inp[j] ~= vs[i][j] then
                _G.StepManager.stop("Wrong output", "Wrong sequence in blue console " .. i .. ".\nExpected " .. vs[i][j] .. " got " .. cbs[i].inp[j]..". Your bot was sacrificed as punishment.")
                return false
            end
        end
    end
    return all
end

extra_info =
[[Each sequence of 3 numbers must be sorted, not the whole sequence of 18 numbers.
- Since this task came directly from the technology department, the I/O is different. The sequences do not have the first number as their size, and you should not output it either.]]

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = function()
    local vec = {}
    for i = 1, 6 do
        vs[i] = {}
        for j = 1, 3 do
            vec[(i - 1) * 3 + j] = random(1, 10)
            vs[i][j] = vec[(i - 1) * 3 + j]
        end
        _G.table.sort(vs[i])
    end
    return vec
end}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "south"}

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooododododododooooo"..
            "ooc...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo............b..ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             ".....w.w.w.w.w.w....."..
             "..wwwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...ww,wwwww,wwwwww..."..
             "...ww,,www,,wwwwww..."..
             "...ww,w,w,w,www,ww..."..
             "...ww,ww,ww,wwwwww..."..
             "...ww,wwwww,www,ww..."..
             "...ww,wwwww,www,ww..."..
             "...wwwwwwwwwwwwwww..."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

function first_completed()
    _G.PopManager.new("No title",
        "Type your message here...",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ...ok ",
            clr = _G.Color.blue()
        })
end
