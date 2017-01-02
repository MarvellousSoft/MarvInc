name = "Fire Fighter"
n = "not decided"

lines_on_terminal = 30
memory_slots = 7

-- Bot
bot = {'b', 'WEST'}

-- name, draw background, image
o = {'obst', false, 'wall_none'}
k = {'bucket', true, 'bucket'}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

local objs

objective_text = "Extinguish all lava"
function objective_checker(room)
    for i = 1, 20 do
        for j = 1, 20 do
            local p = 20 * (i - 1) + j
            local o = room.grid_obj[j][i]
            if objs:sub(p, p) == 'l' and o and o.tp == 'dead' then
                return false
            end
        end
    end
    return true
end

extra_info = nil

grid_obj =  "oooooooooooooooooooo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "oooooooooooooooolkoo"..
            "okkkkkkkkblllllllloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "ooooooooooooooookloo"..
            "oooooooooooooooooooo"
objs = grid_obj

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "grey_tile"
g = "grey_tile"


grid_floor = "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"..
             "w,w,w,w,w,w,w,w,w,w,"..
             ",w,w,w,w,w,w,w,w,w,w"
