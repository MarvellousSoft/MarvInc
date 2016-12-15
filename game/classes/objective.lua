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
    if ALL_OK then
        ALL_OK = nil
        if self.complete then
            self:complete(ROOM)
            self.completed = true
            self.complete = nil
        end
        return true, self
    end
    local done = self:cond(ROOM)
    if done and self.complete then
        self:complete(ROOM)
        self.completed = true
        self.complete = nil
    end
    return done, self
end
