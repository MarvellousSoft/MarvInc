local Ops = require "classes.interpreter.operations"

Code = Class{
    init = function(self, ops, labs)
        self.ops = ops
        self.labs = labs
        self.cur = 1
    end,
    type = 'code'
}

function Code:start()
    local ct = Util.findId("code_tab")
    ct.exec_line = 1
    ct.lock = true
    ct.memory:reset()
end

function Code:step()
    if self.cur and self.cur <= #self.ops then
        local lab = self.ops[self.cur]:execute()
        Util.findId("code_tab").exec_line = self.cur
        if lab then
            self.cur = self.labs[lab]
        else
            self.cur = self.cur + 1
        end
    end
    return self.cur and self.cur <= #self.ops
end

function Code:stop()
    local ct = Util.findId("code_tab")
    ct.exec_line = nil
    ct.lock = false
end
