-- Maze puzzle - with walls

name = "Kind of messed up"
n = "A.1"

lines_on_terminal = 4
memory_slots = 0

-- Bot
bot = {'b', "NORTH", {1, 20}}

-- Objects
_G.getfenv(0)['.'] = nil
x = {"obst", false, "wall_o"}


local done = false
-- Objective
objs = {-- Condition
       {
    function(self, room)
        return room.bot.pos.x == 11 and room.bot.pos.y == 11
    end,
    "Get to the center.", _G.LoreManager.maze1_done
    }
}

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
           ".xxxxxxxxxxxxxxxxxxx"

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
