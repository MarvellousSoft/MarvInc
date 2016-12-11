local op = {}

--[[
Operations are classes that have the following fields:
execute - function that executes the operation, and returns the label of the next operation to be executed, or nil
]]

Walk = Class {}

local function walk_check(t)
    if #t > 3 then return end
    if #t == 1 then return Walk() end
    local nums, alps = 0, 0
    for i = 2, #t do
        if t[i]:match("%a+") ~= t[i] and t[i]:match("%d+") ~= t[i] then
            return
        else
            nums = nums + (t[i]:match("%d+") and 1 or 0)
            alps = alps + (t[i]:match("%a+") and 1 or 0)
        end
    end
    if nums > 1 or alps > 1 then return end
    local w = Walk()
    local accepted = {north = true, west = true, south = true, east = true}
    for i = 2, #t do
        if t[i]:match("%d+") then
            w.x = tonumber(t[i])
            if not w.x or w.x <= 0 or w.x ~= math.floor(w.x) then
                return
            end
        else
            if not accepted[t[i]] then
                return
            else
                w.dir = t[i]
            end
        end
    end
    return w
end

function Walk.create(t)
    return walk_check(t) or "Wrong 'walk' parameters"
end

function Walk:execute()
    StepManager:walk(self.x, self.dir)
end

Turn = Class {
    init = function(self, dir)
        self.dir = dir
    end,
    execute = function(self)
        if self.dir == "counter" or self.dir == "clock" then
            StepManager[self.dir](StepManager)
        else
            StepManager:turn(self.dir)
        end
    end
}

local function turn_check(t)
    if #t ~= 2 then return end
    local accepted = {counter = true, clock = true, north = true, west = true, east = true, south = true}
    if not accepted[t[2]] then return end
    return Turn(t[2])
end

function Turn.create(t)
    return turn_check(t) or "Wrong 'turn' parameters"
end


Nop = Class {
    init = function(self) end,
    execute = function(self) end,
    type = "NOP"
}

Jmp = Class {
    init = function(self, nxt) self.nxt = nxt end,
    execute = function(self) return self.nxt end,
    type = "JMP"
}

function op.read(t)
    if #t == 0 then return Nop() end
    if t[1] == 'walk' then
        return Walk.create(t)
    elseif t[1] == 'turn' then
        return Turn.create(t)
    elseif t[1] == 'nop' then
        if #t ~= 1 then return "Incorrect # of 'nop' parameters"  end
        return Nop()
    elseif t[1] == 'jmp' then
        if #t ~= 2 then return "Incorrect # of 'jmp' parameters" end
        return Jmp(t[2])
    end
end

return op
