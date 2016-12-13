-- Lasers, Consoles and Emitters

name = "Guess the Password"
n = 6

lines_on_terminal=30
memory_slots=4

-- Bot
bot = {'p', "NORTH"}

o = {"obst", false, "wall_none"}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Green block
g = {"console", true, "console", "green", args={}, dir="WEST", x=12, y=11, pass=2}
h = {"emitter", true, "emitter", "green", args={
    x1 = 15, y1 = 10,
    x2 = 3, y2 = 10,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="WEST"}
i = {"emitter", true, "emitter", "green", args={
    x1 = 7, y1 = 15,
    x2 = 7, y2 = 19,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="SOUTH"}

-- Red block
r = {"console", true, "console", "red", args={}, dir="WEST", x=12, y=9, pass=2}
s = {"emitter", true, "emitter", "red", args={
    x1 = 15, y1 = 12,
    x2 = 3, y2 = 12,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="WEST"}
t = {"emitter", true, "emitter", "red", args={
    x1 = 11, y1 = 15,
    x2 = 11, y2 = 19,
    t_args = {
        "ray", true, 0.05, "green"
    }
}, dir="SOUTH"}

-- Blue block
b = {"console", true, "console", "blue", args ={}, dir="NORTH", x=6, y=7, pass=3}
c = {"emitter", true, "emitter", "blue", args={
    x1 = 15, y1 = 8,
    x2 = 3, y2 = 8,
    t_args = {
        "ray", true, 0.05, "blue"
    }
}, dir="WEST"}
d = {"emitter", true, "emitter", "blue", args={
    x1 = 3, y1 = 15,
    x2 = 3, y2 = 19,
    t_args = {
        "ray", true, 0.05, "blue"
    }
}, dir="SOUTH"}

e = nil

-- Bucket
k = {"bucket", true, "bucket"}

init_pos = {6, 2}

-- Objective
objs = {
    { function(self, room)
        local _test = function(which)
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
        _test(b)
        _test(r)
        _test(g)

        return room.bot.pos.x == 19 and room.bot.pos.y == 19
    end, "A former unnatentive intern accidentally switched the lasers on. Unfortunately, we "..
        "forgot the password. We do know that the sum of the digits is 7 and the multiplication "..
        "is 12, with 3 being the first digit. Turn the lasers off with the consoles, get the "..
        "bucket he was carrying, extinguish the fire to unblock the entrance and walk there. We expect "..
        "fewer accidents from now on, hopefully.", _G.LoreManager.lasers_done}
}

extra_info =[[
Each monitor receives only one digit of the password, in order
- The digits are all positive
]]

grid_obj =  "oooooooooooooooooooo"..
             "ooooopeooooooooooooo"..
             "oooooeeooooooooooooo"..
             "oooooeeooooooooooooo"..
             "oooooeeooooooooooooo"..
             "oooooeeooooooooooooo"..
             "ooooobeooooooooooooo"..
             "ooeeeeeeeeeeeeecoooo"..
             "ooeeeeeeeeegoooooooo"..
             "ooeeeeeeeeeeeeehoooo"..
             "ooeeeeeeeeeroooooooo"..
             "ooeeeeeeeeeeeeesoooo"..
             "ooeeeeeeeeeeeeeooooo"..
             "oodoooioootoooeooooo"..
             "ooeoooeoooeoooeooooo"..
             "ooeoooeoooeoooeooooo"..
             "ooeoooeoooeoooeooooo"..
             "ooeoooeoooeoooeooooo"..
             "okeeeeeeeeeeeeeeeleo"..
             "oooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
x = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwww"..
             "wwwwwvvwwwwwwwwwwwww"..
             "wwwwwwvwwwwwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwww"..
             "wwvvvvvvvvvwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwww"..
             "wwvvvvvvvvvwwwwwwwww"..
             "wwvvvvvvvvvvvvvvwwww"..
             "wwvvvvvvvvvvvvvwwwww"..
             "wwvwwwvwwwvwwwvwwwww"..
             "wwvwwwvwwwvwwwvwwwww"..
             "wwvwwwvwwwvwwwvwwwww"..
             "wwvwwwvwwwvwwwvwwwww"..
             "wwvwwwvwwwvwwwvwwwww"..
             "wvvvvvvvvvvvvvvvvvxw"..
             "wwwwwwwwwwwwwwwwwwww"
