--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "GPT Xmas II"
n = "X.5"
test_count = 5

lines_on_terminal = 60
memory_slots = 3

-- Bot
bot = {'b', "NORTH"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}
m = {"obst", false, "dead_body_hair"}

local function char_for(i)
    local c = _G.string.char(_G.string.byte('b') + i)
    if c == 'n' then c = 'y' end
    return c
end

for i = 1, 17 do
    local c = char_for(i)
    local img = 'present_bottom'
    local color = _G.Color.new(random() * 256, 200, 150)
    local dir = 'south'
    env[c] = {'bucket', true, img, args = {content = 'empty', content_args = {color = color, img = 'present_top'}}, dir = dir}
end


-- Objective
objective_text = "Santa's elf has been naughty. Read 9 numbers from the console, indicating how many presents should be given for each child (on each row), and rearrange the current presents."


extra_info =[[
There are at most 50 presents.
- There are at most 9 presents on each row.
- The sum of presents given in the console is the same as the current number of presents.
- The colors of the presents do not matter.
- You have very few registers.
]]

grid_obj =   "---------------------"..
             "---------------------"..
             "---------------------"..
             "---------....--------"..
             "--------......-------"..
             "-------...x..-.------"..
             "m.........b.........-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "m...................-"..
             "---------------------"..
             "---------------------"..
             "---------------------"..
             "---------------------"..
             "---------------------"..
             "---------------------"

local function split_presents(tot)
    local pres = {}
    for i = 1, 9 do
        pres[i] = random(0, _G.math.min(tot, 9))
        tot = tot - pres[i]
    end
    if tot > 0 then
        for i = 1, 9 do
            local add = _G.math.min(tot, 9 - pres[i])
            pres[i] = pres[i] + add
            tot = tot - add
        end
    end
    -- shuffle
    for i = 1, 8 do
        local j = random(i, 9)
        pres[i], pres[j] = pres[j], pres[i]
    end
    return pres
end

local total_presents = random(1, 50)
if current_test == 3 then
    total_presents = 50
elseif current_test == 5 then
    total_presents = 1
end
local pres_out = split_presents(total_presents)
x = {"console", false, "console", "red", args = {vec = pres_out, show_nums = 2}, dir = "south"}

local pres_in = split_presents(total_presents)
for i = 1, 9 do
    for j = 1, pres_in[i], 1 do
        local pos = (i + 5) * _G.COLS + j + 1
        local c = char_for(random(1, 17))
        grid_obj = grid_obj:sub(1, pos - 1) .. c .. grid_obj:sub(pos + 1)
    end
end

function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, 9 do
        for j = 1, pres_out[i], 1 do
            if not room.grid_obj[j + 1][i + 6] or room.grid_obj[j + 1][i + 6].tp ~= 'bucket' then
                return false
            end
        end
    end

    return true
end


-- Floor
w = "white_floor"
env[','] = "black_floor"
z = "red_tile"
u = "green_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
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