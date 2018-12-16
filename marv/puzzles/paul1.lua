--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

-- Lasers, Consoles and Emitters

name = "Guess the Password"
n = "B.1"
test_count = 1

lines_on_terminal=30
memory_slots=4

-- Bot
bot = {'p', "SOUTH"}

o = {"obst", false, "wall_none"}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Green block
g = {"console", true, "console", "green", args={vec = 'output'}, dir="WEST", x=12, y=11, pass=2}
h = {"emitter", true, "emitter", "green", args= {
    x1 = 15, y1 = 10,
    x2 = 3, y2 = 10,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="west"}
i = {"emitter", true, "emitter", "green", args={
    x1 = 7, y1 = 15,
    x2 = 7, y2 = 19,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="SOUTH"}

-- Red block
r = {"console", true, "console", "red", args={ vec = 'output' }, dir="WEST", x=12, y=9, pass=2}
s = {"emitter", true, "emitter", "red", args={
    x1 = 15, y1 = 12,
    x2 = 3, y2 = 12,
    t_args = {
        "ray", true, 0.05, "red"
    }
}, dir="west"}
t = {"emitter", true, "emitter", "red", args={
    x1 = 11, y1 = 15,
    x2 = 11, y2 = 19,
    t_args = {
        "ray", true, 0.05, "red"
    }
}, dir="SOUTH"}

-- Blue block
b = {"console", true, "console", "blue", args ={ vec = 'output' }, dir="NORTH", x=6, y=7, pass=3}
c = {"emitter", true, "emitter", "blue", args={
    x1 = 15, y1 = 8,
    x2 = 3, y2 = 8,
    t_args = {
        "ray", true, 0.05, "blue"
    }
}, dir="west"}
d = {"emitter", true, "emitter", "blue", args={
    x1 = 3, y1 = 15,
    x2 = 3, y2 = 19,
    t_args = {
        "ray", true, 0.05, "blue"
    }
}, dir="SOUTH"}

-- Bucket
k = {'bucket', true, 'bucket', args = {content = 'water'}}

-- Objective
objective_text = "A former unnatentive intern accidentally switched the lasers on. Unfortunately, we "..
                 "forgot the password. We do know that the sum of its digits is 7 and the multiplication "..
                 "is 12, with 3 being the first digit. Turn the lasers off with the consoles, get the "..
                 "bucket he was carrying, extinguish the fire to unblock the entrance and walk there. We expect "..
                 "fewer accidents from now on, hopefully."


local function test(room, which)
    local _c = room.grid_obj[which.x][which.y]
    local _inp = _c.inp
    if #_inp > 0 then
        if which.pass == _inp[#_inp] then
            _c:sleep()
        else
            _c:wakeup()
        end
    end
end

function objective_checker(room)
    test(room, b)
    test(room, r)
    test(room, g)

    return room.bot.pos.x == 19 and room.bot.pos.y == 19
end


extra_info =[[
Each monitor receives only one digit of the password, in order.
- The digits are all positive.
]]

grid_obj =   "ooooooooooooooooooooo"..
             "ooooop.oooooooooooooo"..
             "ooooo..oooooooooooooo"..
             "ooooo..oooooooooooooo"..
             "ooooo..oooooooooooooo"..
             "ooooo..oooooooooooooo"..
             "ooooob.oooooooooooooo"..
             "oo.............cooooo"..
             "oo.........gooooooooo"..
             "oo.............hooooo"..
             "oo.........rooooooooo"..
             "oo.............sooooo"..
             "oo.............oooooo"..
             "oodoooioootooo.oooooo"..
             "oo.ooo.ooo.ooo.oooooo"..
             "oo.ooo.ooo.ooo.oooooo"..
             "oo.ooo.ooo.ooo.oooooo"..
             "oo.ooo.ooo.ooo.oooooo"..
             "ok...............l.oo"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
x = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwwww"..
             "wwwwwwvwwwwwwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwwww"..
             "wwvvvvvvvvvwwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwwww"..
             "wwvvvvvvvvvwwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwwww"..
             "wwvvvvvvvvvvvvvwwwwww"..
             "wwvwwwvwwwvwwwvwwwwww"..
             "wwvwwwvwwwvwwwvwwwwww"..
             "wwvwwwvwwwvwwwvwwwwww"..
             "wwvwwwvwwwvwwwvwwwwww"..
             "wwvwwwvwwwvwwwvwwwwww"..
             "wvvvvvvvvvvvvvvvvvxww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"


function first_completed()
    _G.PopManager.new("You've fixed the fire hazard",
        "Paul will be relieved.",
        _G.CHR_CLR['paul'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " trip on ",
            clr = _G.Color.black()
        }, {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " this guy's crazy ",
            clr = _G.Color.red()
        })
end
