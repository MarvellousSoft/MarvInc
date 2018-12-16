--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Hardester Sort"
-- Puzzle number
n = "C.extra.2"

lines_on_terminal = 40
memory_slots = 2

-- Bot
bot = {'b', "WEST"}

local ans

local function create_vec()
    local v = {2, 1, 0, 3, 0, 4, 0, 2, 2, 0, 4, 3, 2, 1, 4, 3, 2, 1, 0}
    ans = {1, 2, 0, 3, 0, 4, 0, 2, 2, 0, 1, 1, 2, 2, 3, 3, 4, 4, 0}
    for t = 1, 6 do
        local v2 = {}
        for x = 1, 4 do
            local k = random(0, 3)
            for g = 1, k do
                _G.table.insert(v2, x)
                _G.table.insert(ans, x)
            end
        end
        if #v2 == 0 then _G.table.insert(v2, 1) end
        for i = 1, #v2 - 1 do
            local j = random(i, #v2)
            v2[i], v2[j] = v2[j], v2[i]
        end
        for i = 1, #v2 do
            _G.table.insert(v, v2[i])
        end
        _G.table.insert(v, 0)
        _G.table.insert(ans, 0)
    end
    for _, x in _G.ipairs {1, 2, 1, 3, 4, 4, 4, 3, 2, 3, 1, 2, 0} do
        _G.table.insert(v, x)
    end
    for _, x in _G.ipairs {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0} do
        _G.table.insert(ans, x)
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 7}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 7}, dir = "west"}

-- console objects
local gr, bl

function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[i][j]
            if o and o.tp == 'console' and o.ctype == 'output' then
                bl = o
            end
        end
    end
end

-- Objective
objective_text = [[
Read multiple 0-terminated sequences (there is a 0 after each sequence) from the green console.
- Sort each sequence and output it to the blue console, in the same format.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", bl.inp[i] .. " is not " .. ans[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end

extra_info =
[[You only have 2 registers.
- Each number in the sequence is between 1 and 4.
- Each number can be repeated at most 3 times in each sequence.
- Example input: "3 1 2 3 0 2 1 0", the corresponding output is "1 2 3 3 0 1 2 0".]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooocbdooooooooo"..
            "ooooooooooooooooooooo"..
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
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....wwwwwwwwwwww....."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

function first_completed()
    _G.PopManager.new(" SHIIET ",
        "Wow! Congratz.\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " That was hard! ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I AM A GOD OF PROGRAMMING ",
            clr = _G.Color.black()
        })
end
