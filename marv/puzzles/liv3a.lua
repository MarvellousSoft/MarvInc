--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Tile Organizer"
n = "C.3A"
-- unless we want to shuffle the buckets
test_count = 1

lines_on_terminal = 40
memory_slots = 5

-- Bot
bot = {'b', 'EAST'}

-- name, draw background, image
o = {'obst', false, 'wall_none'}
k = {'bucket', true, 'bucket', args = {content = 'water'}}

local floor, objs

--This obviously won't be buckets in the final game.
objective_text = "Move the buckets from the top gray tiles to the bottom gray tiles, mirrored by the black line in the center."
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = COLS * (i - 1) + j
            local o = room.grid_obj[j][(ROWS + 1)- i]
            if objs:sub(p, p) == 'k' and (not o or o.tp ~= 'bucket') then
                return false
            end
        end
    end
    return true
end

extra_info = [[Remember you can't walk through a bucket.
- Use our *productive* new command 'walkc'.
- Mirrored by the black line means, if there is a bucket in column X and 3 rows above the black line, then it should be moved to the same column, but 3 rows *below* the black line.]]

grid_obj =  "....................."..
            "..kk.k..k..k.kk.k.k.."..
            ".....kk....k..kk.k.k."..
            ".kk.kk....k.k.kkkk...".. -- 4
            ".k..kk..k....kk.kk.k.".. -- 5
            ".kkkkkk.....k..k...k.".. -- 6
            ".k...k...k.kk.kk...k.".. -- 7
            ".kkk.kk....kkkk.kk...".. -- 8
            "..kkkk..k..k.kkk.k.k.".. -- 9
            "...k.k..k.kkk.kkkkk..".. -- 10
            "b,,,,,,,,,,,,,,,,,,,.".. -- 11 -- MIRROR
            ".....................".. -- 12
            ".....................".. -- 13
            ".....................".. -- 14
            ".....................".. -- 15
            ".....................".. -- 16
            ".....................".. -- 17
            ".....................".. -- 18
            "....................."..
            "....................."..
            "....................."
objs = grid_obj

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "grey_tile"
g = "grey_tile"


grid_floor = ",,,,,,,,,,,,,,,,,,,,,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",ggggggggggggggggggg,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",rrrrrrrrrrrrrrrrrrr,"..
             ",,,,,,,,,,,,,,,,,,,,,"
floor = grid_floor

function first_completed()
    _G.PopManager.new("Task completed",
        "Cool new command, right?\n\n-- Liv",
        _G.CHR_CLR['liv'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " yep ",
            clr = _G.Color.blue()
        })
end
