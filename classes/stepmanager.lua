local Parser = require "classes.interpreter.parser"

local StepManager = {
    ic = 0,
    timer = Timer.new(),
    hdl = nil,
    parser = nil,
    cmd = nil,
    busy = false,
    args = {},
    r = {}
}

-- Plays a set of instructions until step can no longer parse.
function StepManager:play()
    self:stop()
    self.parser = Parser.parseCode()
    if type(self.parser) ~= "table" then
        self.parser = nil
        return
    end
    -- Gambs for some reason...
    self.call = function()
        self:step()
        if not self.parser then return end
        self.timer.after(1, self.call)
    end
    self.timer.after(1, self.call)
    print(self.timer)
end

function StepManager:step()
    print "TURN"
    if not self.parser then
        print "whyyy"
        return
    end
    if self.busy then
        print("busy", self.r[1])
        if not self:cmd(unpack(self.args)) then
            print "done"
            self.busy = false
            self.cmd = nil
        end
        return
    end

    if self.parser then
        print "try"
        if not self.parser:step() and not self.busy then
            self:stop()
        end
    else self:stop() end
end

function StepManager:walk(x)
    print("torooooo")
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
        print(self.busy)
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
    if self.parser then self.parser:stop() end
    self.parser = nil
end

function StepManager:stop()
    print "stop"
    self:stopNoKill()
    ROOM:kill()
end

function StepManager:update(dt)
    self.timer.update(dt)
end

return StepManager
