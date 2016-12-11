require "classes.primitive"

-- Objective class

-- Condition function must be of the form
-- function(self, room)

-- Reward function must be of the form
-- function(self, room)

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
    local done = self:cond(ROOM)
    if done then
        self:complete(ROOM)
        self.completed = true
    end
    return done, self
end
