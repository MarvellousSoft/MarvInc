--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "GPTIS-9"
n = "X.2"
test_count = 5

lines_on_terminal = 60
memory_slots = 10

-- Bot
bot = {'b', "NORTH"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}

-- Objective
objective_text = [[
Start at the top left console and follow the clues given in the consoles.
- The rules are ^v>< and point to the next console with a clue.
- When you read a 0 instead of a clue, write the total number of clues to the red console.]]

function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, _G.ROWS do
        for j = 1, _G.COLS do
            if room.grid_obj[j][i] and room.grid_obj[j][i].tp == 'bucket' then
                return false
            end
        end
    end

    return true
end

local all_clues = {
    ">>vv<<^><v>>^^<<",
    "><><><><vv",
    "",
    ">vv>^^<vv<^^>v",
    "v>v",
}
_G.assert(#all_clues == test_count)
local clues = {
    {{}, {}, {}},
    {{}, {}, {}},
    {{}, {}, {}},
}
local clue_str = all_clues[current_test]
local ci, cj = 1, 1
for c in clue_str:gmatch "." do
    _G.table.insert(clues[ci][cj], c)
    if c == '^' then
        ci = ci - 1
    elseif c == '<' then
        cj = cj - 1
    elseif c == '>' then
        cj = cj + 1
    else
        ci = ci + 1
        _G.assert(c == 'v')
    end
end
_G.table.insert(clues[ci][cj], 0)

local function create_vec(j, i)
    local ci, cj = (i - 7) / 2, (j - 7) / 2
    return clues[ci][cj]
end

c = {"console", false, "console", "gray", args = {vec = create_vec, show_nums = 1}, dir = "south"}
r = {"console", false, "console", "red", args = {vec = "output"}, dir = "north"}


extra_info =[[
Clues never tell you to go to an invalid console.
- Clues might loop and visit the same console again.
]]

grid_obj =   "---------------------"..
             "---------------------"..
             "---------------------"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---.....c.c.c.....---"..
             "---.....b.........---"..
             "---.....c.c.c.....---"..
             "---...............---"..
             "---.....c.c.c.....---"..
             "---...............---"..
             "---.......r.......---"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---------------------"..
             "---------------------"..
             "---------------------"


-- Floor
w = "white_floor"
env[','] = "black_floor"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwww,www,w,www,wwwww"..
             "wwww,wwwww,wwwww,wwww"..
             "www,wwwww,w,wwwww,www"..
             "ww,wwwww,www,wwwww,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,www,wwwwwww,www,ww"..
             "www,w,wwwwwwwww,w,www"..
             "wwww,wwwwwwwwwww,wwww"..
             "www,w,wwwwwwwww,w,www"..
             "ww,www,wwwwwww,www,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,wwwww,www,wwwww,ww"..
             "www,wwwww,w,wwwww,www"..
             "wwww,wwwww,wwwww,wwww"..
             "wwwww,www,w,www,wwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

local ans = {#clue_str}
function objective_checker(room)
    local bl = room.grid_obj[11][15]
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end

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