name = "Simple Sort"
-- Puzzle number
n = "A.3"

lines_on_terminal = 35
memory_slots = 12

-- Bot
bot = {'b', "SOUTH"}

local vs = {}

local function check_all(self, room)
    local g = room.grid_obj
    local cg = g[3][6]
    local cbs = {}
    local all = true
    for i = 1, 6 do
        cbs[i] = g[4 + 2 * i][5]
        if #cbs[i].inp > 3 then
            _G.StepManager:autofail("Wrong output", "More than 3 numbers in blue console " .. i, "Retry")
            return false
        end
        if #cbs[i].inp < 3 then all = false end
        for j = 1, 3 do
            if cbs[i][j] and cbs[i][j] ~= vs[i][j] then
                _G.StepManager:autofail("Wrong output", "Wrong sequence in blue console " .. i, "Retry")
                return false
            end
        end
    end
    return all
end

-- Objective
objs = {
    {-- Condition function
    check_all, "Read 6 sequences of 3 numbers from the green console, then write them to the 6 blue consoles, from left to right. You must sort these sequences.",
    _G.LoreManager.simple_sort_done}
}

extra_info =
[[Each sequence of 3 numbers must be sorted, not the whole sequence of 18 numbers.]]

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = function()
    local vec = {}
    for i = 1, 6 do
        vs[i] = {}
        for j = 1, 3 do
            vec[(i - 1) * 3 + j] = _G.love.math.random(1, 10)
            vs[i][j] = vec[(i - 1) * 3 + j]
        end
        _G.table.sort(vs[i])
    end
    return vec
end, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "south"}

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooooododododododoooo"..
            "ooc..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo...........b..ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
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
             ".....w.w.w.w.w.w...."..
             "..wwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwww..."..
             "...w,wwwww,wwwwww..."..
             "...w,,www,,wwwwww..."..
             "...w,w,w,w,www,ww..."..
             "...w,ww,ww,wwwwww..."..
             "...w,wwwww,www,ww..."..
             "...w,wwwww,www,ww..."..
             "...wwwwwwwwwwwwww..."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
