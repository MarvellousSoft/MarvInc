require "classes.primitive"
local Color = require "classes.color.color"
require "classes.console"

-- Reader reads a .lua level and converts it into a Puzzle

Reader = Class{
    init = function(self, filename)
        self:read(filename)
    end
}

function Reader:read(filename)
    -- Loads lua file and adds contents to table _t
    local _f, err = love.filesystem.load(filename)
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

    self.puz = Puzzle()
    self.puz.name = _t.name
    self.puz.n = _t.n

    local bot = _t.bot
    for x = 1, COLS do
        for y = 1, ROWS do
            if _t.grid_obj:sub((y - 1) * COLS + x, (y - 1) * COLS + x) == bot[1] then
                self.puz.init_pos = Vector(x, y)
            end
        end
    end

    self.puz.orient = bot[2]

    self.puz.grid_floor = {}
    self.puz.grid_obj = {}
    local k = 1
    for i=1, ROWS do
        self.puz.grid_floor[i] = {}
        self.puz.grid_obj[i] = {}
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
                    table.insert(emitters[_proto[4]], {self.puz.grid_obj, j, i, _proto[3], _proto[2],
                        _proto[4], nil, nil, _proto.args})
                end
            end
            k = k + 1
        end
    end

    k = 1
    for i=1, COLS do
        for j=1, ROWS do
            local _co = _t.grid_obj:sub(k, k)
            self.puz.grid_floor[j][i] = _t[_t.grid_floor:sub(k, k)]
            if _co ~= bot[1] and _t[_co] ~= nil then
                local _proto = _t[_co]
                if _proto[1] ~= "emitter" then
                    local args = {self.puz.grid_obj, j, i, _proto[3], _proto[2], _proto[4],
                        _proto[5], _proto[6], _proto.args}
                    local _obj = nil
                    if _proto[1] == "obst" then
                        _obj = Obstacle(unpack(args))
                    elseif _proto[1] == "dead" then
                        _obj = Dead(unpack(args))
                    elseif _proto[1] == "dead_switch" then
                        _obj = DeadSwitch(unpack(args))
                    elseif _proto[1] == "bucket" then
                        _obj = Bucket(unpack(args))
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
    for _, v in pairs(emitters) do
        Emitter(unpack(v))
    end

    self.puz.objs = {}
    for _, v in pairs(_t.objs) do
        table.insert(self.puz.objs, Objective(v[1], v[2], v[3]))
    end

    self.puz.lines_on_terminal = _t.lines_on_terminal
    self.puz.memory_slots = _t.memory_slots
    self.puz.extra_info = _t.extra_info
end

function Reader:get()
    return self.puz
end
