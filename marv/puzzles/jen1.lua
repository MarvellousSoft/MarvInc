--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

-- Maze puzzle - with walls

name = "Kind of messed up"
n = "A.1"
test_count = 1

lines_on_terminal = 4
memory_slots = 0

-- Bot
bot = {'b', "NORTH"}

-- Objects
_G.getfenv(0)['.'] = nil
x = {"obst", false, "wall_o"}


local done = false
-- Objective
objective_text = "Get to the center."
function objective_checker(room)
    return room.bot.pos.x == 11 and room.bot.pos.y == 12
end

extra_info = [[Remember old commands.]]

grid_obj = "xxxxxxxxxxxxxxxxxxxxx"..
           "....................x"..
           ".xxxxxxxxxxxxxxxxxx.x"..
           ".x................x.x"..
           ".x.xxxxxxxxxxxxxx.x.x"..
           ".x.x............x.x.x"..
           ".x.x.xxxxxxxxxx.x.x.x"..
           ".x.x.x........x.x.x.x"..
           ".x.x.x.xxxxxx.x.x.x.x"..
           ".x.x.x.x....x.x.x.x.x"..
           ".x.x.x.x.xx.x.x.x.x.x"..
           ".x.x.x.x.x..x.x.x.x.x"..
           ".x.x.x.x.xxxx.x.x.x.x"..
           ".x.x.x.x......x.x.x.x"..
           ".x.x.x.xxxxxxxx.x.x.x"..
           ".x.x.x..........x.x.x"..
           ".x.x.xxxxxxxxxxxx.x.x"..
           ".x.x..............x.x"..
           ".x.xxxxxxxxxxxxxxxx.x"..
           ".x..................x"..
           "bxxxxxxxxxxxxxxxxxxxx"

-- Floor
w = "white_floor"
v = "black_floor"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    _G.PopManager.new("You've completed the job",
        "But is Jenny always this... energetic?",
        _G.CHR_CLR['jen'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I hope not ",
            clr = _G.Color.black()
        })
end
