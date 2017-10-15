name = "Cleaner I"
-- Puzzle number
n = "A.6"

lines_on_terminal = 20
memory_slots = 5

-- Bot
bot = {'b', "SOUTH"}

local final
local function create_vec()
    local final = grid_floor
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

local green = _G.Color.white()
-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'empty', content_color = _G.Color.black()}}
c = {'container', false, 'paint', 0.2, 'white', 'solid_lava', args = {content = 'paint', content_color = green}}
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
_G.getfenv()[','] = "red_tile"
r = "red_tile"
g = "black_floor"

final      = "wwwwwwwwwwwwwwwwwwwww"..
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

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
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
The floor is... dirty. The coordinate of the dirty tiles are in the green console. For each pair of numbers (i, j) on the console, clean tile on row i and column j, by painting it using the bucket and the bleach in the container.]]
function objective_checker(room)
    for i = 1, ROWS do
        for j = 1, COLS do
            local p = COLS * (i - 1) + j
            if grid_floor:sub(p, p) == ',' then
                if room.color_floor[j][i] then
                    room.color_floor[j][i] = nil
                    grid_floor = grid_floor:sub(1, p - 1) .. 'w' .. grid_floor:sub(p + 1, #grid_floor)
                    room.grid_floor[j][i] = 'white_floor'
                end
            elseif grid_floor:sub(p, p) == 'w' then
                if room.color_floor[j][i] then
                    _G.StepManager.stop("Cleaned wrong tile", "Tile on row " .. i .. " and column " .. j .. " shouldn't be cleaned.", "Retry")
                    return false
                end
            end
        end
    end
    return grid_floor == final
end

extra_info = [[
Don't waste any bleach.
- All coordinates are between 2 and 20.]]

function first_completed()
    _G.PopManager.new(" PLACEHOLDER ",
        " PLACEHOLDER ",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " PLACEHOLDER ",
            clr = _G.Color.blue()
        })
end
