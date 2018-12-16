--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

-- Maze puzzle - with walls

name = "Kind of even more messed up"
n = "A.2"
test_count = 1

lines_on_terminal = 15
memory_slots = 5

-- Bot
bot = {'b', "NORTH"}

-- Objects
_G.getfenv(0)['.'] = nil
x = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Objective
objective_text = "Get to the center, but harder."
function objective_checker(room)
    return room.bot.pos.x == 11 and room.bot.pos.y == 12
end

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
[[
Jenny will want to hear about this.

You probably shouldn't call her Jenny.
]],
    _G.CHR_CLR['jen'], {
        func = function()
            _G.ROOM:disconnect()
        end,
        text = " ok ",
        clr = _G.Color.black()
    })
end
