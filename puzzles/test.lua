-- This is a test puzzle

name = "The Game"
n = 1

-- Bot
bot = {'b', "NORTH", {19, 20}}

-- Objects
e = nil
o = {"obst", false, "wall_o"}

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.pos.x == 20 and room.bot.pos.y == 1
    end, "Let off some steam, Bennet.",
    function(self, room)
        print("It's not a tumor!")
    end}
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
             "eeeeeeeeeweeeeeeeeee"..
             "eeeeeeeeevwvwvwvwvwe"
