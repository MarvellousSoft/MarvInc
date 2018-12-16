--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "True Democracy"
n = "B.2"

lines_on_terminal = 25
memory_slots = 3

-- Bot
bot = {'b', "SOUTH"}

o = {"obst", false, "wall_none"}
e = nil

local ans
local function create_votes()
    -- sizes and distibution of votes
    local szs = { 5, 10,   7, 40, 13,   1,  2, 3,  4,  5,  6,   7}
    local p0  = {.5, .2,  .7, -1, .3,  .6, .3, 0, .5, .7, .1, .05}
    local p1  = {.5, .6, .25, -1, .7, .35, .3, 0, .3, .2, .2, .05}
    -- randomizing order, except the first
    for i = 2, #szs do
        local j = random(i, #szs)
        szs[i], szs[j] = szs[j], szs[i]
        p0[i], p0[j] = p0[j], p0[i]
        p1[i], p1[j] = p1[j], p1[i]
    end

    local v = {}
    ans = {}
    local add = _G.table.insert
    for si, sz in _G.ipairs(szs) do
        add(v, sz)
        if sz == 40 then
            -- size 40 should be a tie
            local eq = random(10, 18)
            local vot = {}
            for i = 1, eq do add(vot, 0); add(vot, 1); end
            while #vot < sz do add(vot, -1) end
            for i = 1, sz do
                local j = random(i, sz)
                vot[i], vot[j] = vot[j], vot[i]
                add(v, vot[i])
            end
            add(ans, -1)
        else
            local c0, c1 = 0, 0
            for i = 1, sz do
                local r = random()
                if r <= p0[si] then
                    add(v, 0)
                    c0 = c0 + 1
                elseif r <= p0[si] + p1[si] then
                    add(v, 1)
                    c1 = c1 + 1
                else
                    add(v, -1)
                end
            end
            if     c0 > c1 then add(ans, 0)
            elseif c1 > c0 then add(ans, 1)
            else add(ans, -1) end
        end
    end

    return v
end

-- Stack
s = {"console", true, "console", "orange", args = {vec = create_votes}, dir = "NORTH"}

-- Results
y = {"console", true, "console", "green", args = {vec = 'output', show_nums = 10}, dir = "SOUTH"}

extra_info = "LEGALIZE!"

grid_obj = "ooooooooooooooooooooo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeyeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeebeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeseeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeeo"..
           "ooooooooooooooooooooo"

-- Floor
D = "white_floor"
v = "black_floor"
x = "red_tile"

grid_floor = "vvvvvvvvvvvvvvvvvvvvv"..
             "vvvvvvvvvvvvvvvvvvvvv"..
             "vvvvvvvvvvDDvvvvvvvvv"..
             "vvvvvvvvvvDDvvvvvvvvv"..
             "vvvvDvvvvvDDvvvvvDvvv"..
             "vvvvDDvvvvDDvvvvDDvvv"..
             "vvvvvDDvvvDDvvvDDvvvv"..
             "vvvvvDDDvvDDvvDDDvvvv"..
             "vvvvvvDDvvDDvvDDvvvvv"..
             "vvvvvvDDvvDDvvDDvvvvv"..
             "vvDvvvvDDvDDvDDvvvDvv"..
             "vvDDvvvDDvDDvDDvvDDvv"..
             "vvvvDDvvDDDDDDvvDDvvv"..
             "vvvvvDDDDDDDDDDDDDvvv"..
             "vvvvvvvDDDDDDDDvvvvvv"..
             "vvvvvvDDDvDDvDDDvvvvv"..
             "vvvvvDDvvvDDvvvDDvvvv"..
             "vvvvvvvvvvDDvvvvvvvvv"..
             "vvvvvvvvvvDDvvvvvvvvv"..
             "vvvvvvvvvvvvvvvvvvvvv"..
             "vvvvvvvvvvvvvvvvvvvvv"

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
The orange console contains sequences of votes. For each sequence write to the green console the result.
- A nay is represented by a 0.
- A yay is represented by a 1.
- An abstention is represented by a -1. These votes should be ignored.
- For each sequence, write 0 if the nays win, 1 if the yays win, and -1 if there is a tie.]]


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

function first_completed()
    _G.PopManager.new("Res publica",
        "And once again, Democracy saved the day...",
        _G.CHR_CLR['paul'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " did it, really? ",
            clr = _G.Color.red()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " we sure showed them! ",
            clr = _G.Color.blue()
        })
end
