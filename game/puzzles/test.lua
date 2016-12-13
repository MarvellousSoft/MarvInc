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
s = {"dead", true, "ray", 0.05, "green"}

-- options: obst, dead

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.pos.x == 20 and room.bot.pos.y == 1
    end, "Let off some steam, Bennet.",
    function(self, room)
        print("It's not a tumor!")
        _G.MAIN_TIMER.after(1,
        function()
            _G.ROOM:from(_G.Reader("puzzles/maze1.lua"):get())
        end)
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
            "oooooooooesooooooooo"..
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
