name = "Hard Sort"
-- Puzzle number
n = "undecided"

lines_on_terminal = 30
memory_slots = 16

-- Bot
bot = {'b', "SOUTH"}

extra_info = [[
Each sequence is given by its size and then its elements.
- Example: 3 3 1 2 1 3 is sequence (3,1,2) and  (3) and the output should be 3 1 2 3 1 3.
- Sequences will have at most 50 elements (does not fit on registers).
- Each number in the sequence will be between 0 and 9.]]

local function create_vec()
    local v = {}
    local szs = {3, 4, 1, 5, 50, 35}
    for _, sz in _G.ipairs(szs) do
        _G.table.insert(v, sz)
        for i = 1, sz do
            _G.table.insert(v, _G.love.math.random(0, 9))
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = create_vec, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "west"}

-- console objects
local gr, bl

local ans = {}

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, 20 do
        for j = 1, 20 do
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
    -- creates answer
    local v, i = gr.out, 1
    while i <= #v do
        local n = v[i]
        _G.table.insert(ans, n)
        local tmp = {}
        for j = 1, n do
            _G.table.insert(tmp, v[i + j])
        end
        _G.table.sort(tmp)
        for j = 1, n do
            _G.table.insert(ans, tmp[j])
        end
        i = i + n + 1
    end
end

-- Objective
objective_text = [[
Read sequences from the green console and write them, sorted, to the blue console.]]
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

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooooo..........ooooo"..
            "ooooc....b.....doooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "ooooo..........ooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             ".....wwwwwwwwww....."..
             "....wwwwwwwwww,w...."..
             ".....wwwwwwwwww....."..
             ".....w,wwwww,w,....."..
             ".....w,,www,,w,....."..
             ".....w,w,w,w,ww....."..
             ".....w,ww,ww,ww....."..
             ".....w,wwwww,ww....."..
             ".....w,wwwww,ww....."..
             ".....wwwwwwwwww....."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
