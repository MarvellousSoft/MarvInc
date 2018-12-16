--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "List Handler II"
-- Puzzle number
n = "C.6"

lines_on_terminal = 50
memory_slots = 130

-- Bot
bot = {'b', "NORTH"}

local ans = {}
local function create_vec()
    local v = {}
    local sz = {3, 19, 3, 10, 1, 0, 2, 5}
    _G.table.insert(v, 50)
    local tmp = {}
    local rem = 50 - (3 + 19 + 3 + 10 + 1 + 0 + 2 + 5)
    for i = 1, 8 do
        local j = random(i, 8)
        sz[i], sz[j] = sz[j], sz[i]
        for x = 1, sz[i] do
            _G.table.insert(tmp, i)
        end
    end
    local seq = {}
    for i = 1, 8 do seq[i] = {} end
    for i = 1, #tmp do
        local j = random(i, #tmp)
        tmp[i], tmp[j] = tmp[j], tmp[i]
        _G.table.insert(v, tmp[i])
        _G.table.insert(v, random(-99, 99))
        _G.table.insert(seq[tmp[i]], v[#v])
        if rem > 0 and random() <= .1 then
            local pos = {}
            for x = 1, 8 do if #seq[x] > 0 then _G.table.insert(pos, x) end end
            j = pos[random(1, #pos)]
            _G.table.insert(v, -1)
            _G.table.insert(v, j)
            seq[j][#seq[j]] = nil
            rem = rem - 1
        end
    end
    while rem > 0 do
        local pos = {}
        for x = 1, 8 do if #seq[x] > 0 then _G.table.insert(pos, x) end end
        j = pos[random(1, #pos)]
        _G.table.insert(v, -1)
        _G.table.insert(v, j)
        seq[j][#seq[j]] = nil
        rem = rem - 1
    end
    for i = 1, 8 do
        _G.table.insert(ans, #seq[i])
        for j = #seq[i], 1, -1 do
            _G.table.insert(ans, seq[i][j])
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums=10}, dir = "south"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums=10}, dir = "north"}

-- console objects
local bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'console' and o.ctype == 'output' then
                bl = o
            end
        end
    end
end

-- Objective
objective_text =
[[You have to maintain 8 lists, they all start empty.
- Read a sequence of queries from the green console, that means first a number N and then N queries.
- Each query has two numbers: A and B.
  - If A is between 1 and 8, this means you should add number B to the *beginning* of the Ath list.
  - Otherwise A is -1, and you should remove the first number from the Bth list.
- Once the queries are over, output all lists, from the first to the eighth, to the blue console.]]

function objective_checker(room)
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


extra_info =
[[Example: Input "4 1 2 1 3 -1 1 1 -2" means adding 2 then 3 to the first list, removing 3, and then adding -2, and the output should be "2 -2 2 0 0 0 0 0 0 0" since all other lists are empty.
- There will be at most 50 queries.
- There are no input/output consoles, but you have 130 registers.
- Queries are guaranteed to be valid. That is, A and B never have invalid values and no query tries to remove an element from an empty list.
- The numbers can be stored however you like in the registers, what matters is the output.]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oooooooooocoooooooooo"..
            "ooooooooooboooooooooo"..
            "oooooooooo.oooooooooo"..
            "oooooooooo.oooooooooo"..
            "oooooooooodoooooooooo"..
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
v = "black_floor"
r = "red_tile"

grid_floor = "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwwwwwwwwwwwwwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwwwwwwwwwwwwwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwwwwwwwwwwwwwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwwwwwwwwwwwwwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwwwwwwwwwwwwwvwvw"..
             "vwvwvwwwwwwwwwwwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"

function first_completed()
    _G.PopManager.new("Congratz, senior",
        "Now let's sleep off the headache.\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " bring it on ",
            clr = _G.Color.blue()
        })
end
