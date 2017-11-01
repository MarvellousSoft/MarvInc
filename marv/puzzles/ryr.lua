name = "PLACEHOLDER"
-- Puzzle number
n = "RYR"

lines_on_terminal = 20
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}

f = {'bucket', true, 'bucket', args = {content = 'empty'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Objective
objective_text = [[
Do the right thing. Burn the files.]]
function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'bucket' then
                return false
            end
        end
    end
    return true
end

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo...f.............oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo...b.........l...oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "oo.................oo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwww,wwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwww,wwwww,w,wwwwww"..
             "wwwwww,,www,,w,wwwwww"..
             "wwwwww,w,w,w,wwwwwwww"..
             "wwwwww,ww,ww,wwwwwwww"..
             "wwwwww,wwwww,wwwwwwww"..
             "wwwwww,wwwww,wwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    _G.PopManager.new(" placeholder",
        " placeholder ",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " placeholder ",
            clr = _G.Color.blue()
        })
end
