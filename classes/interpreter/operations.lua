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
    execute = function() end
}

function op.read(t)
    if #t == 0 then return Nop() end
    if t[1] == 'walk' then
        if #t ~= 1 then return end
        return Walk()
    elseif t[1] == 'turn' then
        if #t ~= 2 or (t[2] ~= 'clock' and t[2] ~= 'anti') then return end
        return Turn(t[2])
    end
end

return op
