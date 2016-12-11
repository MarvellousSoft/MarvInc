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
    self.parser = Parser.ParseCode()
    self.timer = MAIN_TIMER.every(1, function()
        self:step()
    end)
end

function StepManager:step()
    if self.busy then
        if not self.cmd(unpack(self.args)) then
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
    ROOM:move()
    if x then
        -- Cleanup
        local r = self.r[1] < x
        if not r then
            self.r[1] = nil
            self.args[1] = nil
        end
        return r
    else
        return ROOM.blocked()
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

function StepManager:anti()
    ROOM:anti()
    return false
end

function StepManager:stop()
    MAIN_TIMER.cancel(self.timer)
    self.cmd = nil
    self.parser = nil
end

return StepManager
