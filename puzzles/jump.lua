-- This is a test puzzle

name = "DO YOU EVEN LIFT?"
-- Puzzle number
n = 4

lines_on_terminal = 10
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}

-- Objective
objs = {
    {-- Condition function
    function(self, room)
        return room.bot.steps >= 200
    end, "Get tired. Walk 200 steps.",
    _G.LoreManager.jmp_done}
}

extra_info = "The experiment ends as soon as the objective requirements are completed."

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"..
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
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             ".........v.........."..
             ".........w.........."..
             "...................."..
             "...................."..
             "...................."
