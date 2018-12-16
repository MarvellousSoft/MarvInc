--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Project Brainfuck Phase 1"
-- Puzzle number
n = "C.8"

lines_on_terminal = 50
memory_slots = 50

-- Bot
bot = {'b', "NORTH"}

local ans = {}
local v_code, v_in

local function create_ans()
    local mem, i = {}, 1 -- data and data pointer
    for j = 1, 20 do mem[j] = 0 end
    local inp = 1 -- next position of v_in to read
    for _, op in _G.ipairs(v_code) do
        if     op == '+' then mem[i] = mem[i] + 1
        elseif op == '-' then mem[i] = mem[i] - 1
        elseif op == '.' then _G.table.insert(ans, mem[i])
        elseif op == ',' then mem[i] = v_in[inp]; inp = inp + 1
        elseif op == '<' then i = i == 1 and 20 or i - 1
        elseif op == '>' then i = i == 20 and 1 or i + 1
        else assert(false) end
    end
end

local function add(code, x)
    for i = 1, x, 1 do
        _G.table.insert(code, '+')
    end
    for i = -1, x, -1 do
        _G.table.insert(code, '-')
    end
end

local function ins(code, str)
    for c in str:gmatch('.') do
        _G.table.insert(code, c)
    end
end

local function create_vecs()
    v_code, v_in = {}, {}
    for i = 1, 2 do
        ins(v_code, ',')
        _G.table.insert(v_in, random(-99, 99))
        add(v_code, random(-2, 2))
        if i == 1 then ins(v_code, '>') end
    end
    ins(v_code, '.<.')
    for i = 1, 20 do
        ins(v_code, '<')
        if random() < .2  then
            ins(v_code, ',')
            _G.table.insert(v_in, random(-99, 99))
        end
        if random() < .25 then ins(v_code, '+') end
        if random() < .25 then ins(v_code, '-') end
        if random() < .25 then ins(v_code, '.') end
        add(v_code, random(-2, 2))
    end
    for i = 1, 23 do
        ins(v_code, '.>')
        if random() < .2 then ins(v_code, '-') end
    end
    local pos = {'<', '>', '+', '-', '.', ',', '.', '.'}
    for i = 1, 32 do
        local op = pos[random(1, #pos)]
        ins(v_code, op)
        if op == ',' then _G.table.insert(v_in, random(-99, 99)) end
    end
    ins(v_code, '.')
    create_ans()
end

local function create_code()
    if not v_code then
        create_vecs()
    end
    return v_code
end

local function create_in()
    if not v_code then
        create_vecs()
    end
    return v_in
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_in, show_nums = 9}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 9}, dir = "west"}
e = {"console", false, "console", "white", args = {vec = create_code, show_nums = 11}, dir = "south"}

-- console objects
local bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'console' and #o.out == 0 then
                bl = o
            end
        end
    end
end

-- Objective
objective_text = [[
You must implement a simple brainfuck interpreter. The instructions will be on the white console, the input on the green console and the output must be written to the blue console.
- It should support the instructions ,.<>+-]]
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

extra_info = [[
The size of the cyclic memory should be exactly 20.
- Refer to Liv's email for details on the instructions and language.]]

grid_obj =  "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........o.........."..
            "..........e.........."..
            "ooooooooocbdooooooooo"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwwww"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "www,,wwwwwwwwwww,,www"..
             "wwww,,wwwwwwwww,,wwww"..
             "wwwww,,wwwwwww,,wwwww"..
             "wwwwww,,wwwww,,wwwwww"..
             "wwwwww,,wwwww,,wwwwww"..
             "wwwww,,wwwwwww,,wwwww"..
             "wwww,,wwwwwwwww,,wwww"..
             "www,,wwwwwwwwwww,,www"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwww,,wwwwwwwwwwwww"..
             "wwwwww,,wwwwwwwwwwwww"..
             "wwww,,,,,,w,,,,,,wwww"..
             "wwww,,,,,,w,,,,,,wwww"..
             "w,,www,,wwwwwwwwww,,w"..
             "w,,www,,wwwwwwwwww,,w"..
             "wwwwwwwwwwwwwwwwwww,w"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    _G.PopManager.new("Interpreter working",
        "Phase 2 will start soon\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " ok ",
            clr = _G.Color.blue()
        })
end
