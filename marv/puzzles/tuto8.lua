--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Squaring"
-- Puzzle number
n = 7

lines_on_terminal = 35
memory_slots = 5

-- Bot
bot = {'b', "WEST"}

local bk = {}

-- Objective
objective_text = "For each number in the green console, write its square to the blue console. All numbers are non-negative and not greater than 30."
function objective_checker(room)
    local g = room.grid_obj
    local cg, cb = g[8][8], g[13][8]
    for i = 1, #cb.inp do
        if i >= #bk then return true end
        if cb.inp[i] ~= bk[i] * bk[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. (bk[i] * bk[i]) .. " got " .. cb.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #cb.inp >= #bk
end

extra_info =
[[Remember to use brackets for indirection.
- You may need some copies of the same number. Try using mov.
- If you haven't realized yet, the registers can only hold values between -999 and 999.
]]


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = function()
    local vec = {}
    for i = 1, 11 do
        if i == 7 then
            vec[i] = 0
        elseif i == 10 then
            vec[i] = 30
        else
            vec[i] = random(1, 30)
        end
        bk[i] = vec[i]
    end
    return vec
end}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output'}, dir = "west"}

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo....c....d.....ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo............b..ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooo...............ooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "....................."..
             "....................."..
             "....................."..
             "....................."..
             ".....w.w.w.w.w.w....."..
             "..wwwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...wwwwwwwwwwwwwww..."..
             "...ww,wwwww,wwwwww..."..
             "...ww,,www,,wwwwww..."..
             "...ww,w,w,w,www,ww..."..
             "...ww,ww,ww,wwwwww..."..
             "...ww,wwwww,www,ww..."..
             "...ww,wwwww,www,ww..."..
             "...wwwwwwwwwwwwwww..."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."..
             "....................."

local function after_pop()
    _G.ROOM:disconnect(false)
    _G.Util.findId("pcbox"):changeTabs(_G.Util.findId("pcbox").menu_tabs, "email")
    _G.FX.full_static(_G.GS.ACT1)
    _G.ROOM.version = "1.0"
    _G.ROOM.draw_star = true
    -- Fake puzzle, may change this later
    _G.LoreManager.puzzle_done.tutorial = true
    _G.LoreManager.check_all()
end

function first_completed()
    _G.PopManager.new("Congratulations!",
    "You have passed basic training. We at Marvellous Inc proud ourselves on our "..
    "award-winning hands-on personnel training. A congratulatory golden star sticker has "..
    "been added to the coffee room employee board under your name. Every month we select "..
    "the highest golden sticker ranking employee and hang an Employee of the Month picture "..
    "in the coffee room for this outstanding and obedient member of the Marvellous Inc "..
    "family. The current Employee of the Month for department [ROBOT TESTING] is [FERGUS "..
    "GERHARD JACOBSEN].\n\n"..
    "And remember, efficiency means lower costs. And lower costs means fewer layoffs.\n\n"..
    "    - Christoff J. Kormen, Senior Assistant to the Training Manager",
    _G.Color.blue(), {
        func = after_pop,
        text = " thank you for this wonderful opportunity ",
        clr = _G.Color.blue()
    })
end
