--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Small Division"
-- Puzzle number
n = "C.extra.1"
-- The test cases are the same. The order changes.
test_count = 3

lines_on_terminal = 10
memory_slots = 1

-- Bot
bot = {'b', "WEST"}

local function create_vec()
    local v = {}
    for i = -875, 875, 125 do
        _G.table.insert(v, i)
    end
    for i = 1, #v do
        local j = random(i, #v)
        v[i], v[j] = v[j], v[i]
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

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
end

-- Objective
objective_text = [[
Read numbers from the green console, divide them by 125 and write them to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #gr.out then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= gr.out[i] / 125 then
            _G.StepManager.stop("Wrong output", gr.out[i] .. "/125 is not " .. bl.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #gr.out
end

extra_info =
[[You only have 10 lines and 1 register.
- It is guaranteed numbers are divisible by 125.
- Numbers may be negative or 0.]]

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
    _G.PopManager.new("HOLY FUCK",
        "You actually did it!!!\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " Hell Yeah *puts sunglasses on* ",
            clr = _G.Color.blue()
        })
end
