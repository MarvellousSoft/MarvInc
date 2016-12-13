name = "Sequence Separator"
-- Puzzle number
n = 7

lines_on_terminal = 30
memory_slots = 5

-- Bot
bot = {'b', "SOUTH"}


local freq = {}

local function check_all(self, room)
    local g = room.grid_obj
    local cg, cb, cr = g[10][18], g[4][17], g[16][17]
    ------
    local fr = {}
    for i, v in _G.ipairs(cb.inp) do
        if v >= 0 then
            _G.StepManager:autofail("Wrong output", "Non-negative number in blue console", "Retry")
            return false
        end
        fr[v] = (fr[v] or 0) + 1
        if not freq[v] or fr[v] > freq[v] then
            _G.StepManager:autofail("Wrong output", "Additional number " .. v .. " in blue console", "Retry")
        end
    end

    for i, v in _G.ipairs(cr.inp) do
        if v < 0 then
            _G.StepManager:autofail("Wrong output", "Negative number in red console", "Retry")
            return false
        end
        fr[v] = (fr[v] or 0) + 1
        if not freq[v] or fr[v] > freq[v] then
            _G.StepManager:autofail("Wrong output", "Additional number " .. v .. " in red console", "Retry")
        end
    end

    for v, ct in _G.pairs(freq) do
        if not fr[v] or fr[v] < ct then
            return false
        end
    end
    return true
end

-- Objective
objs = {
    {-- Condition function
    check_all, "Read up to 50 numbers from the green console, and write the negative numbers to the blue console, and the non-negative numbers to the red console.",
    _G.LoreManager.array_sep_done}
}

extra_info =
[[The conditional jumps are jgt, jge, jlt, jle, jeq and jne; to check for greater than, greater or equal, ...you get it.
- The inputs are randomly generated, don't try to memorize them.]]

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = function()
    local vec = {}
    for i = 1, 50 do
        vec[i] = _G.love.math.random(-100, 100)
        freq[vec[i]] = (freq[vec[i]] or 0) + 1
    end
    return vec
end, dir = "north"}
d = {"console", false, "console", "blue", args = {}, dir = "east"}
e = {"console", false, "console", "red", args = {}, dir = "west"}

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooboooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "oood...........eoooo"..
            "ooooooooocoooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "...................."..
             "...................."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             "...wwwwwwwwwwwww...."..
             ".........w.........."..
             "...................."..
             "...................."
