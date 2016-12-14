local Parser = require "classes.interpreter.parser"

local StepManager = {
    ic = 0,
    running = false,
    timer = Timer.new(),
    hdl = nil,
    parser = nil,
    cmd = nil,
    args = {},
    r = {},

    -- Temp code
    tmp = nil,
    delay = 1,
    is_fast = false,

    waiting = false,
    paused = false,

    -- Event has as key the object and as value the condition function.
    events = {}
}


-- Plays a set of instructions until step can no longer parse.
function StepManager:do_play()
    if not ROOM:connected() then
        SFX.buzz:play()
        return
    end
    if self.tmp then
        self.ic = 0
        self.running = true
        self.code = self.tmp
        self.tmp = nil
        self.timer.after(self.delay, self.call)
        return
    end
    self.running = false
    self.ic = 0
    self.code = Parser.parseCode()
    if type(self.code) ~= "table" then
        self.code = nil
        SFX.buzz:play()
        return
    end
    self.code:start()
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
        -- Emit an end turn signal
        Signal.emit("end_turn")
        if not self.code then return end
        self.timer.after(self.delay, self.call)
    end
    self.running = true
    self.timer.after(self.delay, self.call)
end

local function go_speed(self, delay)
    self.delay = delay
    if self.running and not self.waiting then return end
    if self.waiting then
        self.mrk_play = delay
        self:stop()
        return
    end
    self.paused = false
    self.waiting = false
    StepManager:do_play()
end

function StepManager:check_start()
    if self.mrk_play then
        go_speed(self, self.mrk_play)
        self.mrk_play = nil
    end
end

function StepManager:play()
    go_speed(self, 0.5)
end

function StepManager:fast()
    go_speed(self, .05)
end

function StepManager:superfast()
    go_speed(self, .001)
end

function StepManager:pause()
    if not self.running then return end
    self.tmp = self.code
    self.code = nil
    self.timer.clear()
    self.running = false
    self.paused = true
end

function StepManager:step()
    if self.waiting then return end
    self.ic = self.ic + 1
    SFX.click:play()

    if not self.code then
        print "should not be here"
        return
    end

    if self.cmd then
        self:cmd()
    elseif not self.code:step() and not self.cmd then
        self.waiting = true
    end
end

-- Assumes x > 0 or x == nil
function StepManager:walk(x, dir)
    self.cmd = function() self:walk(x and x - 1, dir) end
    ROOM:walk(dir)
    if x == 1 then self.cmd = nil end
    if not x and ROOM:blocked() then
        self.cmd = nil
    end
end

function StepManager:turn(dir)
    ROOM:turn(dir)
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
    if self.tmp then self.tmp, self.code = self.code, self.tmp end
    if self.code then self.code:stop() end
    self.code = nil
    self.running = false
    self.waiting = false
    self.paused = false
end

function StepManager:stop()
    if not self.running and not self.paused then return end
    ROOM:kill()
    self:clear()
end

function StepManager:pickup()
    ROOM:pickup()
    return false
end

function StepManager:drop()
    ROOM:drop()
    return false
end

function StepManager:update(dt)
    self.timer.update(dt)
end

function StepManager:register(evt)
    self.events[evt[1]] = evt[2]
end

function StepManager:removeAll()
    for k, _ in pairs(self.events) do
        self.events[k] = nil
    end
end

function StepManager:clear()
    for k, _ in pairs(self.events) do
        k.completed = false
    end
    Util.findId("code_tab").memory:reset()
end

function StepManager:remove(obj)
    self.events[obj] = nil
end

function StepManager:autofail(title, text, button)
    ROOM.fail_title = title
    ROOM.fail_text = text
    ROOM.fail_button = button
    self:stop()
end

return StepManager
