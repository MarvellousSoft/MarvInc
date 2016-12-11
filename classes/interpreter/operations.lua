local op = {}

--[[
Operations are classes that have the following fields:
execute - function that executes the operation, and returns the label of the next operation to be executed, or nil
]]

Walk = Class {
    execute = function(self)
        StepManager:walk()
    end
}

Turn = Class {
    init = function(self, dir)
        self.dir = dir
    end,
    execute = function(self)
        StepManager[self.dir](StepManager)
    end
}

Nop = Class {
    init = function(self) end,
    execute = function(self) end,
    type = "NOP"
}

Jmp = Class {
    init = function(self, nxt) self.nxt = nxt end,
    execute = function(self) return self.nxt end
}

function op.read(t)
    if #t == 0 then return Nop() end
    if t[1] == 'walk' then
        if #t ~= 1 then return "Incorrect # of 'walk' parameters" end
        return Walk()
    elseif t[1] == 'turn' then
        if #t ~= 2 or (t[2] ~= 'clock' and t[2] ~= 'counter') then
            return "Incorrect 'turn' parameters"
        end
        return Turn(t[2])
    elseif t[1] == 'nop' then
        if #t ~= 1 then return "Incorrect # of 'nop' parameters"  end
        return Nop()
    elseif t[1] == 'jmp' then
        if #t ~= 2 then return "Incorrect # of 'jmp' parameters" end
        return Jmp(t[2])
    end
end

return op
