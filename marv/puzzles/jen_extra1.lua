--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Division II"
-- Puzzle number
n = "A.extra.1"

lines_on_terminal = 10
memory_slots = 1

-- Bot
bot = {'b', "WEST"}

local function create_vec()
    local v = {}
    for i = 1, 5 do
        _G.table.insert(v, random(-200, 200))
    end
    _G.table.insert(v, 0)
    _G.table.insert(v, -742)
    _G.table.insert(v, -683)
    _G.table.insert(v, 900)
    for i = 1, 10 do
        _G.table.insert(v, random(-899, 899))
    end
    _G.table.insert(v, 627)
    _G.table.insert(v, -855)
    _G.table.insert(v, 569)
    _G.table.insert(v, 514)
    _G.table.insert(v, -900)
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

-- console objects
local gr, bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[i][j]
            if o and o.tp == 'console' then
                if #o.out > 0 then
                    gr = o
                else
                    bl = o
                end
            end
        end
    end
end

-- Objective
objective_text = [[
Read numbers from the green console, divide them by 57 and write the result, rounded down and in absolute value, to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #gr.out then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= _G.math.abs(_G.math.floor(gr.out[i] / 57))  then
            _G.StepManager.stop("Wrong output", "abs(" ..gr.out[i] .. "/57) is not " .. bl.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #gr.out
end

extra_info = [[
You only have 10 lines and 1 register.
- To round down a number, choose the largest integer that is less or equal to that number. For example, round(0.1) = 0, while round(-0.1) = -1.
- Example: Input (13, 100, -100) should output (0, 1, 2).
- All numbers are between -900 and 900.]]

grid_obj =  ".........cbd........."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             "ww,,,wwww,,,wwww,,,ww"..
             "www,,,www,,,www,,,www"..
             "wwww,,,ww,,,ww,,,wwww"..
             "wwwww,,,w,,,w,,,wwwww"..
             "wwwwww,,,,,,,,,wwwwww"..
             "wwwwwww,,,,,,,wwwwwww"..
             "wwwwwwww,,,,,wwwwwwww"..
             "wwwwwwwww,,,wwwwwwwww"..
             "wwwwwwww,,,,,wwwwwwww"..
             "wwwwwww,,,,,,,wwwwwww"..
             "wwwwww,,,,,,,,,wwwwww"..
             "wwwww,,,w,,,w,,,wwwww"..
             "wwww,,,ww,,,ww,,,wwww"..
             "www,,,www,,,www,,,www"..
             "ww,,,wwww,,,wwww,,,ww"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"


function first_completed()
    _G.PopManager.new("That was incredible",
        [[
It's hard to admit, but I must say you are a master of optimization.

I'm... proud of you.

And I will never repeat that and deny ever saying it.

Please send your solution to the big bosses, they will certainly congratulate your efforts:

marvellous.amoeba@gmail.com

Carry on, until the end of times.

-Janine]],
        _G.CHR_CLR['jen'],{
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " Thank you Jen ",
            clr = _G.Color.blue()
        },{
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " GG ",
            clr = _G.Color.red()
        })
end
