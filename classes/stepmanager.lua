local Parser = require "classes.interpreter.parser"

local StepManager = {
    ic = 0,
    running = false,
    timer = Timer.new(),
    hdl = nil,
    parser = nil,
    cmd = nil,
    busy = false,
    args = {},
    r = {},

    -- Event has as key the object and as value the condition function.
    events = {}
}

-- Inits
Signal.register("death", function()
    StepManager:stopNoKill()
end)

-- Plays a set of instructions until step can no longer parse.
function StepManager:play()
    if self.running then
        self:stop()
    else
        self:stopNoKill()
    end
    self.running = false
    self.ic = 0
    self.code = Parser.parseCode()
    --self.code:start()
    if type(self.code) ~= "table" then
        self.code = nil
        return
    end
    -- Gambs for some reason...
    self.call = function()
        self:step()
        -- Watch for events (e.g. Objectives)
        for evt, evt_f in pairs(self.events) do
            local done, obj = evt_f(evt)
            if done then
                evt.completed = true
            end
        end
        if not self.code then return end
        self.timer.after(1, self.call)
    end
    self.timer.after(1, self.call)
    self.running = true
end

function StepManager:step()
    self.ic = self.ic + 1 

    if not self.code then
        return
    end
    if self.busy then
        if not self:cmd(unpack(self.args)) then
            self.busy = false
            self.cmd = nil
        end
        return
    end

    if self.code then
        if not self.code:step() and not self.busy then
            self:stop()
            self.running = false
        end
    else
        self:stop()
        self.running = false
    end
end

function StepManager:walk(x)
    self.busy = true
    self.cmd = self.walk
    if x then
        if not self.args[1] then
            self.args[1] = x
            self.r[1] = 0
        else
            self.r[1] = self.r[1] + 1
        end
    end
    ROOM:walk()
    if x then
        -- Cleanup
        local r = self.r[1] < x
        if not r then
            self.r[1] = nil
            self.args[1] = nil
        end
        return r
    else
        return not ROOM:blocked()
    end
end

function StepManager:turn(o)
    ROOM:turn(o)
    return false
end

function StepManager:clock()
    ROOM:clock()
    return false
end

function StepManager:counter()
    ROOM:counter()
    return false
end

function StepManager:stopNoKill()
    self.timer.clear()
    self.cmd = nil
    self.busy = false
    if self.code then self.code:stop() end
    self.code = nil
end

function StepManager:stop()
    self:stopNoKill()
    ROOM:kill()
    self:clear()
end

function StepManager:update(dt)
    self.timer.update(dt)
end

function StepManager:register(evt)
    self.events[evt[1]] = evt[2]
end

function StepManager:clear()
    for k, _ in pairs(self.events) do
        k.completed = false
    end
end

function StepManager:remove(obj)
    self.events[obj] = nil
end

return StepManager
