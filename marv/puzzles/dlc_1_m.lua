--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "MarvGPT Test"
-- Puzzle number
n = "X.3"
test_count = 1

lines_on_terminal = 30
memory_slots = 1

-- Bot
bot = {'b', "WEST"}

local final
local function create_vec(_j, i)
    local v = {}
	for j = 2, COLS - 1 do
		local color = (final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'm')
		if color then
			_G.table.insert(v, j)
		end
	end
	for a = 1, #v - 1 do
		local b = random(a, #v)
		v[a], v[b] = v[b], v[a]
	end
    _G.table.insert(v, 0)
    return v
end

local black = _G.Color.gray()

local function eq_color(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}
d = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = black}}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 1}, dir = "west"}


grid_obj =  "ooooooooooooooooooodo"..
            "o.................kbc"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "o...................c"..
            "ooooooooooooooooooooo"

-- Floor
_G.getfenv()[','] = "white_floor"
r = "red_tile"
g = "black_floor"

grid_floor = ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"

final =      ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,mmmm,,,,,,,,"..
             ",,,,,,,,mmmmmm,,,,,,,"..
             ",,,,,,,,mmmmmm,,,,,,,"..
             ",,,,,,mmmmmmmm,,,,,,,"..
             ",,,,,m,m,mmmm,mmm,,,,"..
             ",,,,m,,,,,mmmmmmmm,,,"..
             ",mm,mm,m,,mmmmmmmmm,,"..
             ",mmm,m,m,,mmmmmmmmm,,"..
             ",,m,,m,m,,mmmmmmmmm,,"..
             ",,m,,,,,,,,,mmmmmm,,,"..
             ",,,m,,,,,mm,m,mmm,,,,"..
             ",,,,m,,,mm,m,,,,,,,,,"..
             ",,,,,mmm,,m,,,,,,,,,,"..
             ",,,,,,mmmmmmm,,,,,,,,"..
             ",,,,mmmmmmmmmm,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"..
             ",,,,,,,,,,,,,,,,,,,,,"

-- Objective
objective_text = [[
You must paint the given tiles room, starting from tile (2, 2) till (20, 19)
- Each row has a console on the right with a 0-terminated list of tiles that should be painted on that row.
- There is paint on the top-right.]]
function objective_checker(room)
    local ok = true
    if room.color_floor[1][1] then
        _G.StepManager.stop("Painted wrong tile", "You weren't supposed to paint this tile. Your bot was sacrificed as punishment.")
        return false
    end
    for i = 2, ROWS - 1 do
        for j = 2, COLS - 1 do
            if final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'm' then
                if not room.color_floor[j][i] then
                    ok = false
                elseif not eq_color(room.color_floor[j][i], black) then
                    _G.StepManager.stop("Painted wrong color", "Tile on row " .. i .. " and column " .. j .. " should be painted. Your bot was sacrificed as punishment.")
                end
            elseif final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Painted wrong tile", "Tile on row " .. i .. " and column " .. j .. " shouldn't be painted. Your bot was sacrificed as punishment.")
                    return false
                end
            end
        end
    end
    return ok
end

extra_info = [[
Nothing is painted on column 20.
- You have just one register.
]]

function first_completed()
    _G.PopManager.new("title placeholder",
        [[completed placeholder]],
        _G.Color.black(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " option 1 placeholder ",
            clr = _G.Color.black()
        })
end
