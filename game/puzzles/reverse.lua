name = "Reverse Sequences"
-- Puzzle number
n = "C.1"

lines_on_terminal = 40
memory_slots = 25

-- Bot
bot = {'b', "EAST"}


local function create_vec()
    local v = {}
    local szs = {3, 4, 1, 5, 20, 15}
    for _, sz in _G.ipairs(szs) do
        _G.table.insert(v, sz)
        for i = 1, sz do
            _G.table.insert(v, _G.love.math.random(-100, 100))
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = create_vec, dir = "west"}
d = {"console", false, "console", "blue", args = {}, dir = "east"}

local con

local ans = {}

-- create ans vector
function on_start(room)
    local v, i = room.grid_obj[10][6].out, 1
    while i <= #v do
        local n = v[i]
        _G.table.insert(ans, n)
        for j = n, 1, -1 do
            _G.table.insert(ans, v[i + j])
        end
        i = i + n + 1
    end
end

-- Objective
objective_text = [[
Read sequences from the green console and write them reversed to the blue console.]]
function objective_checker(room)
    local gr, bl = room.grid_obj[10][6], room.grid_obj[11][6]
    _G.assert(gr.tp == 'console')

    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager:autofail("Wrong output", "Too many numbers!", "Retry")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager:autofail("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i], "Retry")
            return false
        end
    end
    return #bl.inp == #ans
end


extra_info = [[
Each sequence is given by its size and then its elements.
- Example: 2 1 2 1 3 is sequence (1,2) and  (3) and the output should be 1 2 1 1 3.
- Sequences will have at most 20 elements.]]

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooo.....bcd......ooo"..
            "ooo..oooooooooo..ooo"..
            "ooo.oooooooooooo.ooo"..
            "ooo.oooooooooooo.ooo"..
            "ooo.oooooooooooo.ooo"..
            "ooo..oooooooooo..ooo"..
            "ooo..............ooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...wwwwwwwwwwwwww..."..
             "...ww..........ww..."..
             "...w............w..."..
             "...w............w..."..
             "...w............w..."..
             "...ww..........ww..."..
             "...wwwwwwwwwwwwww..."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
