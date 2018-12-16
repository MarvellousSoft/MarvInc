--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Clever Cleaning"
-- Puzzle number
n = "A.3"
test_count = 1

lines_on_terminal = 15
memory_slots = 4

-- Bot
bot = {'b', "NORTH"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'water'}}

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

extra_info = [[You have few lines to use. Be smart.]]

local function after_pop()
    _G.ROOM:disconnect()
end

function first_completed()
    _G.PopManager.new("Well done",
        "You have proven yourself to be an efficient and valuable employee so far.\n\nI'll tell Franz about your success. It's time to carry on.\n\n-Janine",
        _G.CHR_CLR['jen'], {
            func = after_pop,
            text = " I am ready ",
            clr = _G.Color.blue()
        })
end
