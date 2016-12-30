-- Maze puzzle - with walls

name = "Kind of even more messed up"
n = "A.2"

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
    return room.bot.pos.x == 11 and room.bot.pos.y == 11
end

grid_obj = "xxxxxxxxxxxxxxxxxxxx"..
           "...................x"..
           ".xxxxxxxxxxxxxxxxx.x"..
           ".x...............x.x"..
           ".x.xxxxxxxxxxxxx.x.x"..
           ".x.x...........x.x.x"..
           ".x.x.xxxxxxxxx.x.x.x"..
           ".x.x.x.......x.x.x.x"..
           ".x.x.x.xxxxx.x.x.x.x"..
           ".x.x.x.x...x.x.x.x.x"..
           ".x.x.x.x.x.x.x.x.x.x"..
           ".x.x.x.x.xxx.x.x.x.x"..
           ".x.x.x.x.....x.x.x.x"..
           ".x.x.x.xxxxxxx.x.x.x"..
           ".x.x.x.........x.x.x"..
           ".x.x.xxxxxxxxxxx.x.x"..
           ".x.x.............x.x"..
           ".x.xxxxxxxxxxxxxxx.x"..
           ".x.................x"..
           "bxxxxxxxxxxxxxxxxxxx"

-- Floor
w = "white_floor"
v = "black_floor"

grid_floor = "...................."..
             "wwwwwwwwwwwwwwwwwww."..
             "w.................w."..
             "w.wwwwwwwwwwwwwww.w."..
             "w.w.............w.w."..
             "w.w.wwwwwwwwwww.w.w."..
             "w.w.w.........w.w.w."..
             "w.w.w.wwwwwww.w.w.w."..
             "w.w.w.w.....w.w.w.w."..
             "w.w.w.w.www.w.w.w.w."..
             "w.w.w.w.w.w.w.w.w.w."..
             "w.w.w.w.w...w.w.w.w."..
             "w.w.w.w.wwwww.w.w.w."..
             "w.w.w.w.......w.w.w."..
             "w.w.w.wwwwwwwww.w.w."..
             "w.w.w...........w.w."..
             "w.w.wwwwwwwwwwwww.w."..
             "w.w...............w."..
             "w.wwwwwwwwwwwwwwwww."..
             "w..................."

function first_completed()
    _G.PopManager.new("You've completed the job",
[[
Jenny will want to hear about this.

You probably should call her Jenny.
]],
    _G.Color.green(), {
        func = function()
            _G.ROOM:disconnect()
        end,
        text = " ok ",
        clr = _G.Color.black()
    })
end
