--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"
require "classes.console"
local md5 = require "extra_libs.md5"
local LParser = require "lparser.parser"

-- Reader reads a .lua level and converts it into a Puzzle

local reader = {}

-- Reads and returns the puzzle with id puzzle_id
function reader.read(puzzle_id, is_custom, random_seed_mod)
    -- Loads lua file and adds contents to table _t
    local _f, err
    if not is_custom then
        _f, err = love.filesystem.load("puzzles/" .. puzzle_id .. ".lua")
    else
        return LParser.read(puzzle_id)
    end
    if err then print(err) end
    local _t = {}
    setfenv(_f, _t)

    -- Stores constants
    _t.ROWS = ROWS
    _t.COLS = COLS
    _t.print = print
    _t._G = _G
    local seed = tonumber(md5.sumhexa(puzzle_id .. (random_seed_mod or '')):sub(1, 8), 16)
    local rd = love.math.newRandomGenerator(seed)
    _t.random = function(...) return rd:random(...) end

    -- Runs the puzzle script
    _f()

    local puz = Puzzle()
    puz.name = _t.name
    puz.id = puzzle_id
    puz.is_custom = is_custom
    puz.n = _t.n
    puz.postDraw = _t.postDraw
    puz.update = _t.update
    puz.test_count = _t.test_count

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
                    elseif _proto[1] == "computer" then
                        _obj = Computer(unpack(args))
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
    if not is_custom then
        puz.first_completed = _t.first_completed
        puz.already_completed = _t.already_completed
    else
        puz.custom_completed =_t.completed
    end

    puz.lines_on_terminal = _t.lines_on_terminal
    puz.memory_slots = _t.memory_slots
    puz.extra_info = _t.extra_info

    puz.on_start = _t.on_start
    puz.on_end = _t.on_end

    puz.code, puz.renames = SaveManager.load_code(puzzle_id, is_custom)

    return puz
end

return reader
