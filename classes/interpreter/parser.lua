local Ops = require "classes.interpreter.operations"

local parser = {}

function parser.parseLine(s)
    local i = s:find(':')
    local label
    if i then
        if i == 1 then return nil end
        local p = s:sub(1, i)
        s = s:sub(i + 1)
        if s:find(':') then return nil end
        for token in p:gmatch("%w+") do
            if label then return end
            label = token
        end
        if not label then return end
    end

    local t = {}
    for token in s:gmatch("%w+") do
        table.insert(t, token)
    end

    return Ops.read(t), label
end

Code = Class{
    init = function(self, ops, labs)
        self.ops = ops
        self.labs = labs
        self.cur = 1
    end,
    step = function(self)
        local lab = self.ops[self.cur]:execute()
        if lab then
            self.cur = self.labs[lab]
        else
            self.cur = self.cur + 1
        end
        return self.cur and self.cur <= #self.ops
    end
}

function parser.parseAll(lines)
    local code, labs = {}, {}
    for _, line in ipairs(lines) do
        local op, lab = parser.parseLine(line)
        if not op then return end
        table.insert(code, op)
        if lab and labs[lab] then return end
        if lab then labs[lab] = #code end
    end
    return Code(code, labs)
end

function parser.parseCode()
    return parser.parseAll(Util.findId("code_tab").lines)
end

return parser
