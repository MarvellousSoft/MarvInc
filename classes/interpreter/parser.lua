local Ops = require "classes.interpreter.operations"

local parser = {}

function parser.parseLine(s)
    local i = s:find(':')
    local label
    if i then
        if i == 1 then return "No Label" end
        local p = s:sub(1, i)
        s = s:sub(i + 1)
        if s:find(':') then return "Two or more ':'" end
        for token in p:gmatch("%w+") do
            if label then return "Label Wrong" end
            label = token
        end
        if not label then return "No Label" end
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
        Util.findId("code_tab").exec_line = 1
    end,
    step = function(self)
        local lab = self.ops[self.cur]:execute()
        if lab then
            self.cur = self.labs[lab]
        else
            self.cur = self.cur + 1
        end
        if self.cur and self.cur <= #self.ops then
            Util.findId("code_tab").exec_line = self.cur
        end
        return self.cur and self.cur <= #self.ops
    end,
    stop = function(self) Util.findId("code_tab").exec_line = nil end
}

function parser.parseAll(lines)
    local code, labs = {}, {}
    for _, line in ipairs(lines) do
        local op, lab = parser.parseLine(line)
        if type(op) ~= "table" then
            print("ERROR:", op)
            return
        end
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
