--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Prime Decomposition"
n = "E.3"

lines_on_terminal = 40
memory_slots = 6

-- Bot
bot = {'b', 'NORTH'}


local ans
local function create_vec()
    ans = {}
    local v = {2, 3, 4, 5, 6, 7, 100, 99, 97, 64, 90, 49, 81}
    for i = 1, 10 do
        _G.table.insert(v, random(8, 96))
    end
    -- maybe there are too many numbers
    for i = 1, #v do
        local j = random(i, #v)
        v[i], v[j] = v[j], v[i]
        x = v[i]
        y = 2
        while y * y <= x do
            while (x % y) == 0 do
                x = x / y
                _G.table.insert(ans, y)
            end
            y = y + 1
        end
        if x > 1 then _G.table.insert(ans, x) end
    end
    return v
end

-- name, draw background, image
o = {'obst', false, 'wall_none'}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "south"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 20}, dir = "south"}

local bl

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
objective_text = "For each number x on the green console, write all its prime factors (even repeated ones) to the blue console, in non-decreasing order."
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers!. Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end

extra_info =
[[All numbers are between 2 and 100.
- For example, if input is (12 13), output should be (2 2 3 13).]]


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
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oooooooocooodoooooooo"..
            "oooooooob....oooooooo"..
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
             ".....wwwwwwwwwwwww..."..
             "....................."..
             "....................."

function first_completed()
    _G.PopManager.new("Prime Decomposition",
        "I wonder what Miles and Bill were all worried about...",
        _G.CHR_CLR['bm'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = "... and what was Miles talking about?",
            clr = _G.Color.blue()
        })
end
