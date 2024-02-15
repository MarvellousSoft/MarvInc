--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "GPT Xmas I"
n = "X.4"
test_count = 5

lines_on_terminal = 60
memory_slots = 10

-- Bot
bot = {'b', "SOUTH"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}
m = {"obst", false, "dead_body_hair"}

local function char_for(i)
    local c = _G.string.char(_G.string.byte('b') + i)
    if c == 'n' then c = 'y' end
    return c
end

for i = 1, 9 do
    local c = char_for(i)
    local img = 'present_bottom'
    local color = _G.Color.new((i - 1) * 256 / 9, 200, 150)
    local dir = 'south'
    env[c] = {'bucket', true, img, args = {content = 'empty', content_args = {color = color, img = 'present_top'}}, dir = dir}
end


-- Objective
objective_text = [[
This is a game of secret santa. There are 9 presents, one in front of each children, and each of them should go to another child.
- The console has 9 numbers, each X_i between 1 and 9 telling the i-th present should go to child X_i.
- Shuffle the presents according to the consoles.
]]


extra_info =[[
Each child gives one present and gets one present.
- A child never gives a present to themselves.
- You have few registers.
]]

grid_obj =   "---------------------"..
             "---------....--------"..
             "--------......-------"..
             "-------......-.------"..
             "------........-------"..
             "------........-------"..
             "-----..........------"..
             "-----..........------"..
             "------........-------"..
             "------........-------"..
             "-------......--------"..
             "--------....---------"..
             "---------------------"..
             "---------------------"..
             "---------------------"..
             "------mmmmmmmmm------"..
             "------cdefghijk------"..
             "-----.....b.....-----"..
             "----------x----------"..
             "---------------------"..
             "---------------------"

local p = {}
for i = 1, 9 do
    p[i] = i
end
for i = 1, 8 do
    local j = random(i, 9)
    p[i], p[j] = p[j], p[i]
    if p[i] == i then
        p[i], p[i + 1] = p[i + 1], p[i]
    end
end
if p[9] == 9 then
    p[9], p[8] = p[8], p[9]
end

x = {"console", false, "console", "red", args = {vec = p, show_nums = 2}, dir = "north"}

function on_start(room)
    for i = 1, 9 do
        local obj = room.grid_obj[6 + i][17]
        obj.desired_p = p[i]
    end
end

function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, 9 do
        local obj = room.grid_obj[6 + i][17]
        if not obj or obj.tp ~= 'bucket' or obj.desired_p ~= i then return false end
    end

    return true
end


-- Floor
w = "white_floor"
env[','] = "black_floor"
z = "red_tile"
u = "green_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwzzzzwwwwwwww"..
             "wwwwwwwwzzzzzzwwwwwww"..
             "wwwwwwwzzzzzzwuwwwwww"..
             "wwwwww,,,,,,,,wwwwwww"..
             "wwwwww,,wwww,,wwwwwww"..
             "wwwww,,w,ww,w,,wwwwww"..
             "wwwww,,wwwwww,,wwwwww"..
             "wwwwww,,,,,,,,wwwwwww"..
             "wwwwww,,,ww,,,wwwwwww"..
             "wwwwwww,,,,,,wwwwwwww"..
             "wwwwwwww,,,,wwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    _G.PopManager.new("title placeholder",
        [[completed placeholder]],
        _G.CHR_CLR['marvgpt'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " option 1 placeholder ",
            clr = _G.Color.black()
        })
end