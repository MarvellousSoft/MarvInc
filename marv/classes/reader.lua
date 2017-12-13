require "classes.primitive"
local Color = require "classes.color.color"
require "classes.console"

-- Reader reads a .lua level and converts it into a Puzzle

local reader = {}

-- Reads and returns the puzzle with id puzzle_id
function reader.read(puzzle_id)
    -- Loads lua file and adds contents to table _t
    local _f, err = love.filesystem.load("puzzles/" .. puzzle_id .. ".lua")
    if err then print(err) end
    local _t = {}
    setfenv(_f, _t)

    -- Stores constants
    _t.ROWS = ROWS
    _t.COLS = COLS
    _t.print = print
    _t._G = _G

    -- Runs the puzzle script
    _f()

    local puz = Puzzle()
    puz.name = _t.name
    puz.id = puzzle_id
    puz.n = _t.n

    -- If you want to do something on each turn, create a function onTurn(ic), where ic is the
    -- instruction counter.
    if _t.onTurn then
        puz.turn_handler = _t.onTurn
    end

    local bot = _t.bot
    for x = 1, COLS do
        for y = 1, ROWS do
            if _t.grid_obj:sub((y - 1) * COLS + x, (y - 1) * COLS + x) == bot[1] then
                puz.init_pos = Vector(x, y)
            end
        end
    end

    puz.orient = bot[2]

    puz.grid_floor = {}
    puz.grid_obj = {}
    puz.inv_wall = {}
    local k = 1
    for i=1, ROWS do
        puz.grid_floor[i] = {}
        puz.grid_obj[i] = {}
        puz.inv_wall[i] = {}
    end

    -- Searches for emitters before other objects.
    local emitters = {}
    k = 1
    for i=1, COLS do
        for j=1, ROWS do
            local _co = _t.grid_obj:sub(k, k)
            if _t[_co] ~= nil then
                local _proto = _t[_co]
                if _proto[1] == "emitter" then
                    if not emitters[_proto[4]] then emitters[_proto[4]] = {} end
                    assert(_proto.dir)
                    table.insert(emitters[_proto[4]], {puz.grid_obj, j, i, _proto[3], _proto[2],
                        _proto[4], nil, nil, _proto.args, _proto.dir})
                end
            end
            k = k + 1
        end
    end

    k = 1
    for i=1, COLS do
        for j=1, ROWS do
            local _co = _t.grid_obj:sub(k, k)
            puz.grid_floor[j][i] = _t[_t.grid_floor:sub(k, k)]
            puz.inv_wall[j][i] = _t.inv_wall and _t.inv_wall:sub(k, k) == '1'
            if _co ~= bot[1] and _t[_co] ~= nil then
                local _proto = _t[_co]
                if _proto[1] ~= "emitter" then
                    local args = {puz.grid_obj, j, i, _proto[3], _proto[2], _proto[4],
                        _proto[5], _proto[6], _proto.args, _proto}
                    local _obj = nil
                    if _proto[1] == "obst" then
                        _obj = Obstacle(unpack(args))
                    elseif _proto[1] == "dead" then
                        _obj = Dead(unpack(args))
                    elseif _proto[1] == "dead_switch" then
                        _obj = DeadSwitch(unpack(args))
                    elseif _proto[1] == "bucket" then
                        _obj = Bucket(unpack(args))
                    elseif _proto[1] == "container" then
                        _obj = Container(unpack(args))
                    elseif _proto[1] == "console" then
                        -- Adds emitters as clients to a console that shares color.
                        _obj = Console(unpack(args))
                        if emitters[_proto[4]] then
                            for _, v in pairs(emitters[_proto[4]]) do
                                _obj:addClient(Emitter(unpack(v)))
                            end
                            emitters[_proto[4]] = nil
                        end
                    end
                    if _obj and _proto.dir then _obj.r = _G[_proto.dir:upper().."_R"] assert(_obj.r) end
                end
            end
            k = k + 1
        end
    end

    -- Adds standalone emitters.
    for _, pack in pairs(emitters) do
        for _, v in ipairs(pack) do
            Emitter(unpack(v))
        end
    end

    puz.objective_text = _t.objective_text
    puz.objective_checker = _t.objective_checker
    puz.first_completed = _t.first_completed
    puz.already_completed = _t.already_completed

    puz.lines_on_terminal = _t.lines_on_terminal
    puz.memory_slots = _t.memory_slots
    puz.extra_info = _t.extra_info

    puz.on_start = _t.on_start
    puz.on_end = _t.on_end

    puz.code, puz.renames = SaveManager.load_code(puzzle_id)

    return puz
end

return reader
