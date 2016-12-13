-- This is a test puzzle

name = "Hello World"
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

t = {"console", false, "console", "red", args={1, 2, 10,}}
m = {"emitter", true, "emitter", "red", args={
    x1 = 11, y1 = 18,
    x2 = 11, y2 = 20,
    t_args = {
        "ray", true, 0.05, "red", nil
    }
}}

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
            "oooooooooemooooooooo"..
            "oooooooooeeeoooooooo"..
            "oooooooooeeeooooooto"..
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
             "eeeeeeeeewveeeeeeeee"..
             "eeeeeeeeevwveeeeeeee"..
             "eeeeeeeeewvweeeeeeee"..
             "eeeeeeeewvwvwvwvwvwe"
