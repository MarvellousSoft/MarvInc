name = "Squaring"
-- Puzzle number
n = 7

lines_on_terminal = 35
memory_slots = 5

-- Bot
bot = {'b', "WEST"}

local bk = {}

local function check_all(self, room)
    local g = room.grid_obj
    local cg, cb = g[8][8], g[13][8]
    for i = 1, #cb.inp do
        if i >= #bk then return true end
        if cb.inp[i] ~= bk[i] * bk[i] then
            _G.StepManager:autofail("Wrong output", "Expected " .. (bk[i] * bk[i]) .. " got " .. cb.inp[i], "Retry")
            return false
        end
    end
    return #cb.inp >= #bk
end

-- Objective
objs = {
    {-- Condition function
    check_all, "For each number in the green console, write its square to the blue console. All numbers are non-negative and not greater than 30.",
    _G.LoreManager.square_done}
}

extra_info =
[[Remember to use brackets.
- You may need some copies of the same number. Try using mov.
- If you haven't realized yet, the registers can only hold values between -999 and 999.
]]


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = function()
    local vec = {}
    for i = 1, 10 do
        vec[i] = _G.love.math.random(1, 30)
        bk[i] = vec[i]
    end
    return vec
end, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "west"}

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooo..............ooo"..
            "ooo..............ooo"..
            "ooo....c....d....ooo"..
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
