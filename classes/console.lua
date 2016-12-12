require "classes.primitive"
local Color = require "classes.color.color"

-- Console class

Console = Class{
    __includes = {Object},
    -- may receive a vector or a function that receives the coordinates and creates the vector
    init = function(self, grid, i, j, key, bg, color, __, ___, args)
        Object.init(self, grid, i, j, "console", bg)
        self.color = Color[color or "white"](Color)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        -- Optional emitters
        self.clients = {}
        self.clients_awake = true
        self.first = true

        self.out = type(args) == 'table' and args or args(i, j)
        self.inp = {}
        self.i = 1
    end
}

-- Signals all clients to sleep.
function Console:sleep()
    for _, v in ipairs(self.clients) do
        v:sleep()
    end
    self.awake = false
end

-- Signals all clients to wakeup.
function Console:wakeup()
    for _, v in ipairs(self.clients) do
        v:wakeup()
    end
    self.awake = true
end

-- Toggles clients to wakeup or sleep.
function Console:toggleClients()
    if self.awake then self:sleep() else self:wakeup() end
end

-- Adds an emitter to this console.
function Console:addClient(e)
    table.insert(self.clients, e)
end

function Console:input()
    if self.i > #self.out then return end
    self.i = self.i + 1
    return self.out[self.i - 1]
end

function Console:write(val)
    if #self.out > 0 then return "Trying to write to input-only console" end
    if #self.inp >= 500 then return "Trying to put too many numbers on console" end
    table.insert(self.inp, val)
end
