name = "Explorer"
-- Puzzle number
n = "undecided"

lines_on_terminal = 25
memory_slots = 6

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}

local floor

grid_obj =  "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "....................."..
            ".o.o.o.o.o.o.o.o.o.o."..
            "b...................."

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
g = "green_tile"

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

local fl = 1 -- bot
for i = 1, ROWS * COLS do
    if grid_obj:sub(i, i) == '.' then
        fl = fl + 1
    end
end

-- Objective
objective_text = "Step on each non-wall tile at least once."
local visit, cur
function on_start() visit, cur = {}, 0 end
function objective_checker(room)
    local pos = room.bot.pos.y * COLS + room.bot.pos.x
    if not visit[pos] then
        visit[pos] = 1
        cur = cur + 1
    end
    return cur >= fl
end

extra_info = nil

function first_completed()
    _G.PopManager.new("blahblahblah",
        "blahblahblahblah",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " blah ",
            clr = _G.Color.blue()
        })
end
