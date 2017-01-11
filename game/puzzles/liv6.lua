name = "Complete Brainfuck Interpreter"
-- Puzzle number
n = "C.6"

lines_on_terminal = 60
memory_slots = 40

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
        _G.table.insert(v_in, _G.love.math.random(-99, 99))
        add(v_code, _G.love.math.random(-2, 2))
        if i == 1 then ins(v_code, '>') end
    end
    ins(v_code, '.<.')
    for i = 1, 20 do
        ins(v_code, '<')
        if _G.love.math.random() < .2  then
            ins(v_code, ',')
            _G.table.insert(v_in, _G.love.math.random(-99, 99))
        end
        if _G.love.math.random() < .25 then ins(v_code, '+') end
        if _G.love.math.random() < .25 then ins(v_code, '-') end
        if _G.love.math.random() < .25 then ins(v_code, '.') end
        add(v_code, _G.love.math.random(-2, 2))
    end
    for i = 1, 23 do
        ins(v_code, '.>')
        if _G.love.math.random() < .2 then ins(v_code, '-') end
    end
    local pos = {'<', '>', '+', '-', '.', ',', '.', '.'}
    for i = 1, 32 do
        local op = pos[_G.love.math.random(1, #pos)]
        ins(v_code, op)
        if op == ',' then _G.table.insert(v_in, _G.love.math.random(-99, 99)) end
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
c = {"console", false, "console", "green", args = create_in, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "west"}
e = {"console", false, "console", "white", args = create_code, dir = "south"}

-- console objects
local bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, 20 do
        for j = 1, 20 do
            local o = room.grid_obj[i][j]
            if o and o.tp == 'console' and #o.out == 0 then
                bl = o
            end
        end
    end
end

-- Objective
objective_text = [[
You must implement a brainfuck interpreter. The instructions will be on the white console, the input on the green console and the output must be written to the blue console.
- It should support the instructions ,.<>+-[]
- After the instructions, there will be a number 0 on the white console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers!", "Retry")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i], "Retry")
            return false
        end
    end
    return #bl.inp == #ans
end

extra_info = [[
The size of the cyclic memory should be exactly 20.
- There will be at most 100 instructions.
- The will be at most 5 levels of nested loops.
- Refer to Liv's email for details on the instructions and language.]]

grid_obj =  "oooooooooooooooooooo"..
            ".........oo........."..
            ".........oo........."..
            ".........oo........."..
            ".........oo........."..
            ".........oo........."..
            ".........oo........."..
            ".........oo........."..
            ".........eo........."..
            "oooooooocbdooooooooo"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"..
            "wwwwwwwwwwwwwwwwwwww"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwww"..
             "ww,,wwwwwllwwwww,,ww"..
             "www,,wwwwllwwww,,www"..
             "wwww,,wwwllwww,,wwww"..
             "wwwww,,wwllww,,wwwww"..
             "wwwww,,wwllww,,wwwww"..
             "wwww,,wwwllwww,,wwww"..
             "www,,wwwwllwwww,,www"..
             "ww,,wwwwwwwwwwww,,ww"..
             "lllllllllwwlllllllll"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwww,,wwwwwwwwwwww"..
             "wwwwww,,wwwwwwwwwwww"..
             "wwww,,,,,,w,,,,,wwww"..
             "wwww,,,,,,w,,,,,wwww"..
             "w,,www,,wwwwwwwww,,w"..
             "w,,www,,wwwwwwwww,,w"..
             "wwwwwwwwwwwwwwwwww,w"..
             "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwww"
