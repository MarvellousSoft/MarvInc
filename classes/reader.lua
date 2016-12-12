require "classes.primitive"

-- Reader reads a .lua level and converts it into a Puzzle

Reader = Class{
    init = function(self, filename)
        self:read(filename)
    end
}

function Reader:read(filename)
    -- Loads lua file and adds contents to table _t
    local _f = loadfile(filename)
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
    local pos = bot[3]
    self.puz.init_pos = Vector(pos[1], pos[2])
    self.puz.orient = bot[2]

    self.puz.grid_floor = {}
    self.puz.grid_obj = {}
    local k = 1
    for i=1, ROWS do
        self.puz.grid_floor[i] = {}
        self.puz.grid_obj[i] = {}
    end
    for i=1, COLS do
        for j=1, ROWS do
            local _co = _t.grid_obj:sub(k, k)
            self.puz.grid_floor[j][i] = _t[_t.grid_floor:sub(k, k)]
            if _co ~= bot[1] and _t[_co] ~= nil then
                local _proto = _t[_co]
                if _proto[1] == "obst" then
                    Obstacle(self.puz.grid_obj, j, i, _proto[3], _proto[2])
                elseif _proto[1] == "dead" then
                    Dead(self.puz.grid_obj, j, i, _proto[3], _proto[2])
                end
            end
            k = k + 1
        end
    end

    self.puz.objs = {}
    for _, v in pairs(_t.objs) do
        table.insert(self.puz.objs, Objective(v[1], v[2], v[3]))
    end

    self.puz.lines_in_terminal = _t.lines_in_terminal
    self.puz.memory_slots = _t.memory_slots
end

function Reader:get()
    return self.puz
end
