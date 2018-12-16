--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "List Handler I"
-- Puzzle number
n = "C.5"

lines_on_terminal = 40
memory_slots = 20

-- Bot
bot = {'b', "WEST"}

local ans = {}
local function create_vec()
    local v = {}
    local sz = {3, 25, 4, 10, 1, 0, 2, 5}
    _G.table.insert(v, 3 + 25 + 4 + 10 + 1 + 0 + 2 + 5)
    local tmp = {}
    for i = 1, 8 do
        local j = random(i, 8)
        sz[i], sz[j] = sz[j], sz[i]
        if i == 7 and sz[8] == 0 then
            -- empty list can't be the last, or some faulty code might get AC
            sz[7], sz[8] = sz[8], sz[7]
        end
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
    end
    for i = 1, 8 do
        _G.table.insert(ans, #seq[i])
        for j = 1, #seq[i], 1 do
            _G.table.insert(ans, seq[i][j])
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec}, dir = "east"}
d = {"console", false, "console", "orange", args = {vec = 'IO', show_nums = 8}, dir = "south"}
e = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

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
- Each query has 2 numbers A and B, this means you should add number B to the end of the Ath list.
- Once the queries are over, output all lists, from the first to the eighth, to the blue console. Use the usual sequence formatting, that is, size first and then the elements.]]

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


extra_info =
[[Example: Input 3 1 2 2 3 1 -2 means adding 2 and -2 to the first list and 3 to the second list, and should output 2 2 -2 1 3 0 0 0 0 0 0
- There will be at most 50 queries.
- The orange consoles are input/output, that means you can write and read from them. They work like queues, you always read (and then erase) the first item you added.]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooododododododododooo"..
            "oocb..............eoo"..
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
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"..
             "wvwvwvwvwvwvwvwvwvwvw"

function first_completed()
    _G.PopManager.new("GET HYPE",
        "REMEMBER THE PARTY IS TODAY\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " PARTY HARD ",
            clr = _G.Color.blue()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I'll be there ",
            clr = _G.Color.black()
        })
end
