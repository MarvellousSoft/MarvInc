name = "PLACEHOLDER"
-- Puzzle number
n = "RYR"

lines_on_terminal = 20
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
_G.getfenv()['A'] = {"obst", false, "building_corner", dir = "west"}
_G.getfenv()['B'] = {"obst", false, "building_corner", dir = "east"}
_G.getfenv()['C'] = {"obst", false, "building_corner", dir = "south"}
_G.getfenv()['D'] = {"obst", false, "building_corner", dir = "north"}
_G.getfenv()['>'] = {"obst", false, "building_wall", dir = "west"}
_G.getfenv()['<'] = {"obst", false, "building_wall", dir = "east"}
_G.getfenv()['^'] = {"obst", false, "building_wall", dir = "south"}
_G.getfenv()['v'] = {"obst", false, "building_wall", dir = "north"}
_G.getfenv()['o'] = {"obst", false, "building_outside"}
_G.getfenv()['x'] = {"obst", false, "wall_none"}

f = {'bucket', true, 'papers', args = {content = 'empty', content_color = _G.Color.transp()}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}
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
    if papers.dropped_on_computer then
        print "FEDS"
    else
        print "MARVINC"
    end
    return true
end

inv_wall =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooAvvvvvvvvvvvvvvvBoo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>111............<oo"..
            "oo>111............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "oo>...............<oo"..
            "ooC^^^^^^^^^^^^^^^Doo"..
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
            "x..t.f..h.<oooooooooo"..
            "x...c.....<oooooooooo"..
            "x.........<oooooooooo"..
            "x.........<oooooooooo"..
            "x..b.....l<oooooooooo"..
            "x.........<oooooooooo"..
            "x.........<oooooooooo"..
            "x.........<oooooooooo"..
            "^^^^^^^^^^Boooooooooo"..
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
    local v = _G.love.math.random() * 5 + 5
    if _G.love.math.random() < .5 then v = -v end
    return v
end


for i = 1, 4 do
    clouds[i] = {
        x = _G.love.math.random() * TW / 2 + TW / 2,
        y = _G.love.math.random() * TH,
        sx = rnd_vel(),
        sy = rnd_vel(),
        img = _G.OBJS_IMG.bucket
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
            c.x = _G.love.math.random() * (mxx - mnx) + mnx
            if c.sy > 0 then
                c.y = -c.img:getWidth()
            else
                c.y = TH
            end
        end
    end
end

function postDraw()
    for _, c in _G.ipairs(clouds) do
        _G.love.graphics.draw(c.img, c.x, c.y)
    end
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
