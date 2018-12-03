--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Ops = require "classes.interpreter.operations"
require "classes.interpreter.code"

local parser = {}

function parser.parseLine(s, renames)
    local i = s:find('#')
    if i then s = s:sub(1, i - 1) end
    i = s:find(':')
    local label
    if i then
        if i == 1 then return "No Label" end
        local p = s:sub(1, i - 1)
        s = s:sub(i + 1)
        if s:find(':') then return "Two or more ':'" end
        for token in p:gmatch("%S+") do
            if label then return "Label Wrong" end
            label = token
        end
        if not label then return "No Label" end
        if label:match("%w+") ~= label then return "Invalid Label" end
    end

    local t = {}
    for token in s:gmatch("%S+") do
        table.insert(t, token)
    end

    local op = Ops.read(t, renames)
    if not op and #t > 0 then op = "Invalid '" .. t[1] .. "' parameters" end

    return op, label
end

function parser.parseAll(lines, renames)
    local code, labs = {}, {}
    -- instruction code[i] is on line real_line[i] (may be different than i if there are empty lines)
    local real_line = {}
    -- labels that are referenced in the code
    local ref_labels = {}
    local bad_lines = {}
    local err_line, err_msg
    for i, line in ipairs(lines) do
        -- ignoring whitespaces and comments line
        if line:match("%s*") ~= line and line:match("%s*#.*") ~= line then
            local op, lab = parser.parseLine(line, renames)
            if type(op) ~= "table" then
                err_line, err_msg = err_line or i, err_msg or (op or "compilation error")
                bad_lines[i] = true
            end
            table.insert(code, op)
            table.insert(real_line, i)
            if lab and labs[lab] then
                err_line, err_msg = err_line or i, err_msg or "two labels with the same name"
                bad_lines[i] = true
                bad_lines[real_line[labs[lab]]] = true
            end
            if lab then labs[lab] = #code end
        end
    end
    for i, op in ipairs(code) do
        if op.lab and type(op.lab.lab) == 'string' and not labs[op.lab.lab] then
            err_line, err_msg = err_line or real_line[i], err_msg or "invalid label"
            bad_lines[real_line[i]] = true
        end
    end
    if next(bad_lines) then return bad_lines, err_line, err_msg end
    if #code == 0 then
        return
    end
    return Code(code, labs, real_line)
end

function parser.parseCode()
    local code_tab = Util.findId('code_tab')
    local c = parser.parseAll(code_tab:getLines(), code_tab.renames)
    if type(c) == 'table' and c.type == 'code' then return c end
end

return parser
