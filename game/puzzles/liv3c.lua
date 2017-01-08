name = "Stacker"
-- Puzzle number
n = "C.3C"

lines_on_terminal = 35
memory_slots = 30

-- Bot
bot = {'b', "SOUTH"}

local ans = {}

local function create_vec()
    local v, st, ops = {}, {}, 0
    for i = 1, 30 do
        local x = _G.love.math.random() <= .7 and 43 or 45
        if #st == 0 then x = 43 end
        if #st == 20 then x = 45 end
        _G.table.insert(v, x)
        if x == 43 then
            _G.table.insert(v, _G.love.math.random(-999, 999))
            _G.table.insert(st, v[#v])
        else
            _G.table.insert(ans, st[#st])
            st[#st] = nil
        end
    end
    ops = 30
    while #st > 0 do
        _G.table.insert(v, 45)
        _G.table.insert(ans, st[#st])
        st[#st] = nil
        ops = ops + 1
    end
    while ops < 100 do
        local x = _G.love.math.random() <= (1 - .8 * #v / 100) and 43 or 45
        if #st == 0 then x = 43 end
        if #st == 20 then x = 45 end
        _G.table.insert(v, x)
        if x == 43 then
            _G.table.insert(v, _G.love.math.random(-999, 999))
            _G.table.insert(st, v[#v])
        else
            _G.table.insert(ans, st[#st])
            st[#st] = nil
        end
        ops = ops + 1
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = create_vec, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "west"}

-- console objects
local gr, bl

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
end

-- Objective
objective_text = [[
You must implement a stack. This stack is a list, and supports the following operations, read from the green console.
    +: read a number from the green console and add it to the end of the list.
    -: remove the last number from the list and write it to the blue console.]]
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
Example: "+ 2 + 3 - + 5 - -" should output "3 5 2"
- The stack will have at most 20 elements on it at a time
- There will be at most 100 operations]]

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
