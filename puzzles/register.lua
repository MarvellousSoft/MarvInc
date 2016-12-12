-- This is a test puzzle

name = "Basic Programming"
-- Puzzle number
n = 6

lines_on_terminal = 20
memory_slots = 1

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {}, dir = "west"}

local con

local function check_all(self, room)
    if not con then
        for i = 1, 20 do
            for j = 1, 20 do
                local o = room.grid_obj[i][j]
                if o and o.tp == "console" then
                    con = o
                end
            end
        end
    end
    ------
    if #con.inp == 0 then return false end
    for i = 1, #con.inp do
        if con.inp[i] ~= i then
            _G.StepManager:autofail("Wrong output", "Expected " .. i .. " got " .. con.inp[i], "Retry")
            return false
        end
    end
    return #con.inp >= 50
end

-- Objective
objs = {
    {-- Condition function
    check_all, "Write all numbers from 1 to 50 on the green console.",
    _G.LoreManager.register_done}
}

extra_info = "After you outputted the 50 numbers, the code will stop automatically, so there is no need to do it manually."

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooooooooo.....cooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "ooooooooo.oooooooooo"..
            "oooooooooboooooooooo"..
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
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             ".........wwwwww....."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             ".........w.........."..
             "...................."..
             "...................."..
             "...................."
