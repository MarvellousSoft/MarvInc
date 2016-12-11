require "classes.primitive"

-- Objective class

Objective = Class{
    init = function(self, condition, desc, reward)
        self.cond = condition
        self.desc = desc
        self.complete = reward
        self.completed = false
    end
}

function Objective:activate()
    StepManager:register({self, self.wrapper})
end

function Objective:wrapper()
    local done = self:cond()
    if done then
        self:complete()
        self.completed = true
    end
    return done, self
end
