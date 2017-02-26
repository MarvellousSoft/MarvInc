name = "Freelancer Painter"
-- Puzzle number
n = "undecided"

lines_on_terminal = 20
memory_slots = 5

-- Bot
bot = {'b', "SOUTH"}

local final
local function create_vec()
    local tmp = {}
    for i = 1, ROWS do
        for j = 1, COLS do
            if final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                _G.table.insert(tmp, {i, j})
            end
        end
    end
    local v = {}
    for i = 1, #tmp do
        local j = _G.love.math.random(i, #tmp)
        tmp[i], tmp[j] = tmp[j], tmp[i]
        _G.table.insert(v, tmp[i][1])
        _G.table.insert(v, tmp[i][2])
    end
    return v
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty'}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint'}}
h = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "west"}


grid_obj =  "cbhoooooooooooooooooo"..
            "ok..................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "o...................o"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"
g = "black_floor"

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

final =      "wwwwwwwwwwwwwwwwwwwww"..
             "w,,,,,,,wwwwwwwwww,,w"..
             "ww,wwww,,,wwwwwww,www"..
             "www,w,,www,wwwwwwwwww"..
             "wwww,wwwww,wwwwwwwwww"..
             "wwww,wwwww,wwwwwwwwww"..
             "wwww,wwwwww,wwwwwwwww"..
             "wwww,ww,ww,w,wwwwwwww"..
             "wwww,ww,ww,ww,wwwwwww"..
             "wwww,www,wwwww,wwwwww"..
             "www,wwww,,wwwww,wwwww"..
             "www,wwwwwwwwwwww,wwww"..
             "www,ww,www,wwww,wwwww"..
             "www,ww,,,,,www,wwwwww"..
             "www,wwwwwwww,wwwwwwww"..
             "www,wwwwww,wwwwwwwwww"..
             "www,,,ww,wwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwww,www"..
             "w,,wwwwwwwwwwwwwwww,w"..
             "wwwwwwwwwwwwwwwwwwwww"

-- Objective
objective_text = [[
For each pair of numbers (x, y) on the green console, paint tile on row x and column y in black.]]
function objective_checker(room)
    local ok = true
    for i = 1, ROWS do
        for j = 1, COLS do
            if final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == ',' then
                if not room.color_floor[j][i] then
                    ok = false
                end
            elseif final:sub(COLS * (i - 1) + j, COLS * (i - 1) + j) == 'w' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Painted wrong place", "Tile on row " .. i .. " and column " .. j .. " shouldn't be painted.", "Retry")
                    return false
                end
            end
        end
    end
    return ok
end

extra_info = [[All coordinates are between 2 and 20.]]

function first_completed()
    _G.PopManager.new("THANK YOU my friend",
        "You really are the bigger person",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " Glad to help ",
            clr = _G.Color.blue()
        })
end
