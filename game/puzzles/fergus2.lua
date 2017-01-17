name = "Advanced Bucket Mover"
-- Puzzle number
n = "D.2"

lines_on_terminal = 45
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {"bucket", true, "bucket"}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

local floor

-- Objective
objective_text =
[[Step on the red tile.
- Then move the buckets to the green tiles.
- Then step on the blue tile three times.]]

local prog
function on_start(room) prog = 0 end
function objective_checker(room)
    if prog == 0 and room.bot.pos.x == 18 and room.bot.pos.y == 7 then
        prog = 1
    end
    if prog == 1 then
        local b1, b2, b3 = room.grid_obj[9][13], room.grid_obj[10][13], room.grid_obj[11][13]
        if b1 and b2 and b3 and b1.tp == b2.tp and b2.tp == b3.tp and b1.tp == 'bucket' then
            prog = 2
        end
    end
    if (prog == 2 or prog == 4 or prog == 6) and room.bot.pos.x == 17 and room.bot.pos.y == 11 then
        prog = prog + 1
    end
    if (prog == 3 or prog == 5) and (room.bot.pos.x ~= 17 or room.bot.pos.y ~= 11) then
        prog = prog + 1
    end
    return prog == 7
end

extra_info = nil

grid_obj =  "b.....o............."..
            "ooooo.o.ooooooooooo."..
            "ooooo.o.o........lo."..
            "ooooo.....oooooo.oo."..
            "ooooolo.oooooooo.oo."..
            "ooooooo.oooooooo.oo."..
            "ooooooo.oooooooo...."..
            "ooooooo.oooooooolooo"..
            "ooooooo.oooooooooooo"..
            "ooooooo.kkklooollloo"..
            "ooooooo....loool.loo"..
            "ooooooo....loool.loo"..
            "ooooooo....loooo.ooo"..
            "ooooooo.oooooooo.ooo"..
            "ooooooo.oloooooo.ooo"..
            "ooooooo.o....ooo.ooo"..
            "ooooooo...oo..oo.ooo"..
            "ooooooolooooo....loo"..
            "oooooooooooooooooooo"..
            "oooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"
g = "green_tile"
b = "blue_tile"

grid_floor = "wwwwww.wwwwwwwwwwwww"..
             ".....w.w...........w"..
             ".....w.w.wwwwwwwww.w"..
             ".....wwwww......w..w"..
             ".....w.w........w..w"..
             ".....w.w........w..w"..
             ".....w.w........wrww"..
             ".......w........w..."..
             ".......w............"..
             ".......wwww....www.."..
             ".......wwww....wbw.."..
             ".......wwww....www.."..
             ".......wggg.....w..."..
             ".......w........w..."..
             ".......w.w......w..."..
             ".......w.wwww...w..."..
             ".......www..ww..w..."..
             ".......w.....wwwwww."..
             ".......w............"..
             "...................."
floor = grid_floor

function first_completed()
    _G.PopManager.new("Well done",
        "I'm sure this was a real challenge for you.",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " go back ",
            clr = _G.Color.blue()
        })
end
