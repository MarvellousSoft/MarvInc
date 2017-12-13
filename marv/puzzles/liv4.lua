name = "Dequer"
-- Puzzle number
n = "C.4"

lines_on_terminal = 35
memory_slots = 30

-- Bot
bot = {'b', "WEST"}

local ans = {}

local function add_op(v, dq, x)
    _G.table.insert(v, x)
    if x == '+' then
        _G.table.insert(v, _G.love.math.random(0, 999))
        dq.r = dq.r + 1
        dq[dq.r] = v[#v]
    elseif x == '<' then
        _G.table.insert(ans, dq[dq.l])
        dq.l = dq.l + 1
    else
        _G.table.insert(ans, dq[dq.r])
        dq.r = dq.r - 1
    end
end

local function create_vec()
    local v, dq = {}, {l = 1, r = 0}
    for i = 1, 30 do
        local m = _G.love.math.random() <= .5 and '<' or '>'
        local x = _G.love.math.random() <= .85 and '+' or m
        if dq.r < dq.l then x = '+' end
        if dq.r - dq.l + 1 == 20 then x = m end
        add_op(v, dq, x)
    end
    local ops = 30
    while dq.r >= dq.l do
        local x = _G.love.math.random() <= .5 and '<' or '>'
        add_op(v, dq, x)
        ops = ops + 1
    end
    while ops < 100 do
        local m = _G.love.math.random() <= .5 and '<' or '>'
        local x = _G.love.math.random() <= (1 - .6 * ops / 100) and '+' or m
        if dq.r < dq.l then x = '+' end
        if dq.r - dq.l + 1 == 20 then x = m end
        add_op(v, dq, x)
        ops = ops + 1
    end
    return v
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

-- console objects
local gr, bl

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
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
You must implement a deque. This deque is a list, and supports the following operations, read from the green console.
    +: read a number from the green console and add it to the end of the list.
    <: remove the first number from the list and write it to the blue console.
    >: remove the last number from the list and write it to the blue console.]]
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
Example: "+ 2 + 3 < + 5 > <" should output "2 5 3"
- The deque will have at most 20 elements on it at a time
- There will be at most 100 operations]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooo...........ooooo"..
            "ooooc....b......doooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
            "ooooo...........ooooo"..
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
             "....................."..
             "....................."

function first_completed()
    _G.PopManager.new("Deque completed",
        "Thanks. Franz will be pleased.\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " no probs ",
            clr = _G.Color.blue()
        })
end
