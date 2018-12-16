--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Greatest Common Divisor"
-- Puzzle number
n = "E.1"

lines_on_terminal = 20
memory_slots = 6

-- Bot
bot = {'b', "NORTH"}

local function gcd(a, b) return b == 0 and a or gcd(b, a % b) end

local ans
local function create_vec()
    ans = {}
    local v = {}
    local lim = {{1, 5}, {1, 50}, {100, 123}, {200, 400}, {500, 999}}
    local mx = {30, 999, 999, 999, 999}
    local tim = {5, 5, 5, 4, 2}
    for i = 1, #tim do
        for j = 1, tim[i] do
            local x = random(lim[i][1], lim[i][2])
            _G.table.insert(v, x * random(1, _G.math.floor(mx[i] / x)))
            _G.table.insert(v, x * random(1, _G.math.floor(mx[i] / x)))
            _G.table.insert(ans, gcd(v[#v], v[#v - 1]))
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 6}, dir = "south"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 6}, dir = "south"}

-- console objects
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
objective_text = [[
For each pair of numbers (x, y) in the green console, write their greatest common divisor to the blue console.
- The greatest common divisor of x and y is the largest number z such that z divides both x and y.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
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

extra_info = [[
All numbers are between 1 and 999.
- Example: for input "3 5 10 6" the output should be "1 2".]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooocooodooooooooo"..
            "ooooo..b.......oooooo"..
            "ooooo..........oooooo"..
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
             "......wwwwwwww......."..
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
    _G.PopManager.new("Greatest Common Divisor",
        "Billy boy would be proud.",
        _G.CHR_CLR['bm'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I like math ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I hate math ",
            clr = _G.Color.red()
        })
end
