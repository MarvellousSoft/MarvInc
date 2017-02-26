-- First puzzle

name = "Hello World"
-- Puzzle number
n = 1

lines_on_terminal = 100
memory_slots = 0

-- Bot
bot = {'b', "WEST", {19, 20}}

-- Objects
e = nil
-- name, draw background, image
o = {"obst", false, "wall_none"}

-- options: obst, dead

-- Objective
objective_text = "Just get to the red tile. It's not that hard."

function objective_checker(room)
    return room.bot.pos.x == 21 and room.bot.pos.y == 1
end

-- Extra info to be displayed
extra_info = nil

grid_obj =  "oooooooooeeeeeeeeeeee"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeooooooooooo"..
            "oooooooooeeeeeeeeeeeb"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "vwvwvwvwvwvwvwvwvwvwr"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvww"..
             "wvwvwvwvwvwvwvwvwvwvw"..
             "vwvwvwvwvwvwvwvwvwvwv"
