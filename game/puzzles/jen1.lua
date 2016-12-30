-- Maze puzzle - with walls

name = "Kind of messed up"
n = "A.1"

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
    return room.bot.pos.x == 11 and room.bot.pos.y == 11
end

extra_info = [[Remember old commands.]]

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
        "But is Jenny always this... energetic?",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I hope not ",
            clr = _G.Color.black()
        })
end
