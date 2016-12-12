-- This is a test puzzle

name = "The Game"
-- Puzzle number
n = 1

lines_on_terminal = 10
memory_slots = 10

-- Bot
bot = {'b', "NORTH", {19, 20}}

-- Objects
e = nil
-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args={bucketable = true}}

t = {"console", false, "console", "red", args={1, 2, 10}}



-- options: obst, dead

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.pos.x == 20 and room.bot.pos.y == 1
    end, "Just get to the red tile. It's not that hard.",
    _G.LoreManager.first_done}
}

extra_info = nil

grid_obj =  "oooooooooeeeeeeeeeee"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooelloooooooo"..
            "oooooooooellooooooto"..
            "ooooooookeeeeeeeeebo"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "eeeeeeeeewvwvwvwvwvr"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeeveeeeeeeeee"..
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeewvwvwvwvwvwe"
