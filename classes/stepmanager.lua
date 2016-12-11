local Parser = require "classes.interpreter.parser"

local StepManager = {
    ic = 0,
    timer = nil,
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
    self.timer = MAIN_TIMER.every(1, function()
        self:step()
    end)
end

function StepManager:step()
    print "TURN"
    if self.busy then
        print("busy", self.r[1])
        if not self:cmd(unpack(self.args)) then
            print "done"
            self.busy = false
            self.cmd = nil
        end
        return
    end

    if not self.parser:step() then
        self:stop()
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

function StepManager:stop()
    if self.timer then
        MAIN_TIMER.cancel(self.timer)
    end
    self.cmd = nil
    self.busy = false
    if self.parser then self.parser:stop() end
    self.parser = nil
end

return StepManager
