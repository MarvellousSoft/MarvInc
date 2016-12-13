-- This is a test puzzle

name = "Basic Firefighting"
-- Puzzle number
n = 5

lines_on_terminal = 20
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

local function check_all(self, room)
    return room.bot.pos.x == 9 and room.bot.pos.y == 14
end

-- Objective
objs = {
    {-- Condition function
    check_all, "Get to the red tile. Extinguish all the lava in the way using the giant buckets. Obviously.",
    _G.LoreManager.pickup_done}
}

extra_info =
[[If the robot tries to pick something that isn't an object, drops something in a blocked space or drops something with an empty inventory, the simulation will throw an error.]]

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "ooooookooooooooooooo"..
            "oooook.l...koooooooo"..
            "oooooo.ooooloooooooo"..
            "oooooobooooloooooooo"..
            "oooooooo....oooooooo"..
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
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "......w............."..
             ".....wwwwwww........"..
             "......w....w........"..
             "......w....w........"..
             "........rwww........"..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."..
             "...................."
