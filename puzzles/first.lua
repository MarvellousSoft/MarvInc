-- This is a test puzzle

name = "The Game"
-- Puzzle number
n = 1

-- Bot
bot = {'b', "NORTH", {19, 20}}

-- Objects
e = nil
-- name, draw background, image
o = {"obst", false, "wall_o"}

-- options: obst, dead

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.pos.x == 20 and room.bot.pos.y == 1
    end, "Just get to the red tile. It's not that hard.",
    _G.LoreManager.puzzle2}
}

grid_obj = "oooooooooeeeeeeeeeee"..
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
            "oooooooooeoooooooooo"..
            "oooooooooeoooooooooo"..
            "oooooooooeeeeeeeeebo"

-- Floor
w = "white_floor"
v = "black_floor"

grid_floor = "eeeeeeeeewvwvwvwvwvw"..
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
             "eeeeeeeeewveeeeeeeee"..
             "eeeeeeeeevwvwvwvwvwe"
