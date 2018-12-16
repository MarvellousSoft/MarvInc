--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Least Common Multiple"
-- Puzzle number
n = "E.2"

lines_on_terminal = 35
memory_slots = 8

-- Bot
bot = {'b', "NORTH"}

local function gcd(a, b) return b == 0 and a or gcd(b, a % b) end

local ans
local function create_vec()
    ans = {}
    local v = {}
    local lim = {{1, 30}, {10, 120}, {200, 440}, {400, 600}, {500, 999}}
    local mx = {30, 999, 999, 999, 999}
    local tim = {3, 2, 1, 3, 4}
    _G.table.insert(v, 1)
    _G.table.insert(v, 1)
    _G.table.insert(ans, 1)
    for i = 1, #tim do
        for j = 1, tim[i] do
            local x = random(lim[i][1], lim[i][2])
            local pos = {}
            for k = 1, x do
                if (x % k) == 0 then
                    _G.table.insert(pos, k)
                end
            end
            _G.table.insert(v, _G.math.max(random(1, #pos), random(1, #pos)))
            _G.table.insert(v, _G.math.max(random(1, #pos), random(1, #pos)))
            _G.table.insert(ans, v[#v] * v[#v - 1] / gcd(v[#v], v[#v - 1]))
        end
    end
    local rest = {{31, 29}, {19 * 2, 23 * 2}, {25 * 7, 25 * 3}, {31 * 2 * 5, 31 * 3 * 5}, {9 * 37, 27}}
    for _, t in _G.ipairs(rest) do
        _G.table.insert(v, t[1])
        _G.table.insert(v, t[2])
        _G.table.insert(ans, v[#v] * v[#v - 1] / gcd(v[#v], v[#v - 1]))
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 5}, dir = "south"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 5}, dir = "south"}

-- console objects
local bl

-- create ans vector
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
For each pair of numbers (x, y) in the green console, write their least common multiple to the blue console.
- The least common multiple of x and y is the smallest number z such that both x and y divide z.]]
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
- The answer is always between 1 and 999. Be careful with number limits.
- You may find useful to copy and paste the code from the previous task.]]

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
    _G.PopManager.new("Least Common Multiple",
        "Your math is almost as sharp as Bill's dance moves.",
        _G.CHR_CLR['bm'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " *dance* ",
            clr = _G.Color.blue()
        })
end
