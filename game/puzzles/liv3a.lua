name = "Tile Organizer"
n = "C.3A"

lines_on_terminal = 40
memory_slots = 5

-- Bot
bot = {'b', 'EAST'}

-- name, draw background, image
o = {'obst', false, 'wall_none'}
k = {'bucket', true, 'bucket'}

local floor, objs

--This obviously won't be buckets in the final game.
objective_text = "Move the buckets from the top gray tiles to the bottom gray tiles, mirrored by the black line in the center"
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = ROWS * (i - 1) + j
            local o = room.grid_obj[j][(COLS + 2)- i]
            if objs:sub(p, p) == 'k' and (not o or o.tp ~= 'bucket') then
                return false
            end
        end
    end
    return true
end

extra_info = [[Remember you can't walk through a bucket
- Use our *productive* new command 'walkc'
- Mirrored by the black line means, if there is a bucket, in column X, 3 rows above the black line, then it should be moved to the same column, but 3 rows *below* the black line]]

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "o...................o"..
            "o.k.kk....k.k.kkkk..o".. -- 4
            "o...kk..k....kk.kk..o".. -- 5
            "o.kkkkk.....k..k....o".. -- 6
            "o....k...k.kk.kk....o".. -- 7
            "o.kk.kk....kkkk.kk..o".. -- 8
            "o.kkkk..k..k.kkk.k..o".. -- 9
            "o..k.k..k.kkk.kkkk..o".. -- 10
            "o.b,,,,,,,,,,,,,,,..o".. -- 11 -- MIRROR
            "o...................o".. -- 12
            "o...................o".. -- 13
            "o...................o".. -- 14
            "o...................o".. -- 15
            "o...................o".. -- 16
            "o...................o".. -- 17
            "o...................o".. -- 18
            "o...................o"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"
objs = grid_obj

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "grey_tile"
g = "grey_tile"


grid_floor = "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"..
             "o,,,,,,,,,,,,,,,,,,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,gggggggggggggggg,,o"..
             "o,,,,,,,,,,,,,,,,,,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,rrrrrrrrrrrrrrrr,,o"..
             "o,,,,,,,,,,,,,,,,,,,o"..
             "ooooooooooooooooooooo"..
             "ooooooooooooooooooooo"
floor = grid_floor

function first_completed()
    _G.PopManager.new("Task completed",
        "Cool new command, right?\n-- Liv",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " Yep ",
            clr = _G.Color.blue()
        })
end
