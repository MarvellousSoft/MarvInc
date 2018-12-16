--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "The End"
-- Puzzle number
n = "RYR"
test_count = 1

lines_on_terminal = 20
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

local function window_drop(self, bot)
    bot.inv.delivered_to_feds = 'drop'
end

local function window_walk(self, bot)
    if bot and bot.inv ~= nil then
        bot.inv.delivered_to_feds = 'jump'
        bot.inv = nil
    end
end

-- name, draw background, image
_G.getfenv()['A'] = {"obst", false, "building_corner", dir = "west"}
_G.getfenv()['B'] = {"obst", false, "building_corner", dir = "east"}
_G.getfenv()['C'] = {"obst", false, "building_corner", dir = "south"}
_G.getfenv()['D'] = {"obst", false, "building_corner", dir = "north"}
_G.getfenv()['>'] = {"obst", false, "building_wall", dir = "west"}
_G.getfenv()['<'] = {"obst", false, "building_wall", dir = "east"}
_G.getfenv()['X'] = {"obst", false, "building_window", dir = "east", args = {onInventoryDrop = window_drop, onWalk = window_walk}}
_G.getfenv()['^'] = {"obst", false, "building_wall", dir = "south"}
_G.getfenv()['W'] = {"obst", false, "building_window", dir = "south", args = {onInventoryDrop = window_drop, onWalk = window_walk}}
_G.getfenv()['v'] = {"obst", false, "building_wall", dir = "north"}
_G.getfenv()['o'] = {"obst", false, "building_outside"}
_G.getfenv()['x'] = {"obst", false, "building_inner"}


f = {'bucket', true, 'papers', args = {content = 'empty', content_color = _G.Color.transp()}}
L = {"dead_switch", false, "fireplace", 0.1, "white", "solid_lava", args = {bucketable = true, sh = 3*(_G.ROOM_CH/216), post_draw=true}}
l = {"dead_switch", false, "fireplace", 0.2, "white", "solid_lava", args = {bucketable = true, no_draw = true}}
t = {'bucket', true, 'table', args = {content = 'empty', pickable = false, w = _G.ROOM_CW * 3, h = _G.ROOM_CH * 2}}
c = {'computer', true, 'console', args = {color = _G.Color.gray()}, dir="south"}
h = {'bucket', true, 'bucket', args = {content = 'empty'}}

local papers
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'bucket' and o.img == _G.OBJS_IMG.papers then
                papers = o
            end
        end
    end
end

-- Objective
objective_text = [[
Do the right thing. Burn the files.]]
function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'bucket' and o.img == _G.OBJS_IMG.papers then
                return false
            end
        end
    end
    if papers.delivered_to_feds then
        print("FEDS via " .. papers.delivered_to_feds)
        if papers.delivered_to_feds == 'jump' then
            _G.AchManager.complete("Better Years to Come...")
            _G.Gamestate.push(_G.GS.CUTSCENE, "assets/cutscenes/body_drop.png", 12, 15, 8)
        elseif papers.delivered_to_feds == 'computer' then
            _G.AchManager.complete("Better Years to Come...")
            _G.Gamestate.push(_G.GS.COMP)
        else
            _G.AchManager.complete("Better Years to Come...")
            _G.Gamestate.push(_G.GS.CUTSCENE, "assets/cutscenes/paper_drop.png", 12, 15, 8)
        end
    else
        _G.AchManager.complete("A New Dawn")
        _G.Gamestate.push(_G.GS.FIREPLACE)
    end
    return true
end

inv_wall =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "vvvvvvvvvvDoooooooooo"..
            "x..111....<oooooooooo"..
            "x..111....<oooooooooo"..
            "x.........Xoooooooooo"..
            "x........1<oooooooooo"..
            "x..b.....1<oooooooooo"..
            "x........1<oooooooooo"..
            "x.........Xoooooooooo"..
            "x.........<oooooooooo"..
            "^^W^^^^W^^Boooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "vvvvvvvvvvDoooooooooo"..
            "x..t.f....<oooooooooo"..
            "x...c.....<oooooooooo"..
            "x.........Xoooooooooo"..
            "x........l<oooooooooo"..
            "x..b.....L<oooooooooo"..
            "x........l<oooooooooo"..
            "x.........Xoooooooooo"..
            "x.........<oooooooooo"..
            "^^W^^^^W^^Boooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "building_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

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

local clouds = {}

local TW = _G.ROOM_CW * COLS
local TH = _G.ROOM_CH * ROWS

local function rnd_vel()
    local v = random() * 5 + 5
    if random() < .5 then v = -v end
    return v
end


for i = 1, 4 do
    clouds[i] = {
        x = random() * TW / 2 + TW / 2,
        y = random() * TH,
        sx = rnd_vel(),
        sy = rnd_vel(),
        img = _G.OBJS_IMG.cloud_1
    }
end

local function in_screen(x, y, w, h)
    return not (x > TW or x + w < 0 or y > TH or y + h < 0)
end

function update(dt)
    for _, c in _G.ipairs(clouds) do
        c.x = c.x + c.sx * dt
        c.y = c.y + c.sy * dt
        if not in_screen(c.x, c.y, c.img:getWidth(), c.img:getHeight()) then
            c.sx = rnd_vel()
            c.sy = rnd_vel()
            local mnx, mxx = 0, TW
            if c.sx > 0 then mxx = mxx / 2
            else mnx = mxx / 2 end
            c.x = random() * (mxx - mnx) + mnx
            if c.sy > 0 then
                c.y = -c.img:getWidth()
            else
                c.y = TH
            end
        end
    end
end

function postDraw()

    local f = function()
        _G.love.graphics.rectangle("fill", 0,0, COLS*_G.ROOM.grid_cw, ROWS*_G.ROOM.grid_ch)
    end
    _G.love.graphics.stencil(f, "replace", 1)

    _G.love.graphics.setStencilTest("greater", 0)
    _G.love.graphics.setColor(255,255,255)
    for _, c in _G.ipairs(clouds) do
        _G.love.graphics.draw(c.img, c.x, c.y)
    end
    _G.love.graphics.setStencilTest()
end

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
