local Ops = require "classes.interpreter.operations"
require "classes.interpreter.code"

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

function parser.parseAll(lines)
    local code, labs = {}, {}
    -- labels that are referenced in the code
    local ref_labels = {}
    local bad_lines = {}
    for i, line in ipairs(lines) do
        local op, lab = parser.parseLine(line)
        if type(op) ~= "table" then
            --print(i, "ERROR:", op)
            bad_lines[i] = true
        end
        table.insert(code, op)
        if lab and labs[lab] then
            --print(i, "ERROR:", "two labels with the same name")
            bad_lines[i] = true
            bad_lines[labs[lab]] = true
        end
        if lab then labs[lab] = #code end
    end
    while #code > 0 and code[#code].type == "NOP" do
        code[#code] = nil
    end
    for i, op in ipairs(code) do
        if op.type == "JMP" and not labs[op.nxt] then
            --print(i, "ERROR:", "invalid label for jump")
            bad_lines[i] = true
        end
    end
    if next(bad_lines) then return bad_lines end
    if #code == 0 then
        --print("ERROR:", "no code")
        return
    end
    return Code(code, labs)
end

function parser.parseCode()
    local c = parser.parseAll(Util.findId("code_tab").lines)
    if type(c) == 'table' and c.type == 'code' then return c end
end

return parser
