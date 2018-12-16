--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Hard Sort I"
-- Puzzle number
n = "C.7A"

lines_on_terminal = 30
memory_slots = 16

-- Bot
bot = {'b', "SOUTH"}

extra_info = [[
Each sequence is given by its size and then its elements.
- Example: 3 3 1 2 1 3 is sequence (3,1,2) and  (3) and the output should be 3 1 2 3 1 3.
- Sequences will have at most 50 elements (does not fit on registers).
- Each number in the sequence will be between 0 and 9.]]

local function create_vec()
    local v = {}
    local szs = {3, 4, 1, 5, 50, 35}
    for _, sz in _G.ipairs(szs) do
        _G.table.insert(v, sz)
        for i = 1, sz do
            _G.table.insert(v, random(0, 9))
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 5}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 5}, dir = "west"}

-- console objects
local gr, bl

local ans = {}

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
    -- creates answer
    local v, i = gr.out, 1
    while i <= #v do
        local n = v[i]
        _G.table.insert(ans, n)
        local tmp = {}
        for j = 1, n do
            _G.table.insert(tmp, v[i + j])
        end
        _G.table.sort(tmp)
        for j = 1, n do
            _G.table.insert(ans, tmp[j])
        end
        i = i + n + 1
    end
end

-- Objective
objective_text = [[
Read sequences from the green console and write them, sorted, to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got  "  .. bl.inp[i] .. ".  Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooo..........oooooo"..
            "ooooc....b.....dooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
            "ooooo..........oooooo"..
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
             ".....wwwwwwwwwww....."..
             "....wwwwwwwwww,ww...."..
             ".....wwwwwwwwwww....."..
             ".....w,wwwww,w,w....."..
             ".....w,,www,,w,w....."..
             ".....w,w,w,w,www....."..
             ".....w,ww,ww,www....."..
             ".....w,wwwww,www....."..
             ".....w,wwwww,www....."..
             ".....wwwwwwwwwww....."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

function first_completed()
    _G.PopManager.new("Great!",
        "You used counting sort, right?\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " yes ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " nope ",
            clr = _G.Color.black()
        })
end
