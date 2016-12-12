local op = {}

--[[ Number class holds a number... Or what can become one. ]]

Number = Class {}

function Number:init(num, indir)
    self.num = num
    self.indir = indir
end

local function number_eval(mem, indir, orig)
    if indir == 0 then return orig end
    return mem:get(number_eval(mem, indir - 1, orig))
end

-- returns nil if something invalid happened
function Number:evaluate()
    return number_eval(Util.findId("code_tab").memory, self.indir, self.num)
end

local function valid_num(x) return type(x) == 'number' and x >= -999 and x <= 999 end

-- Returns a new Number created from string s, or nil if it is invalid
function Number.create(s)
    if s:match("%a") or not s:match("%d") then return end
    if not s:match("[%[%]]") then return valid_num(tonumber(s)) and Number(tonumber(s), 0) end
    if s:match("[%[%]0-9]+") ~= s then return end
    local lvl, bak = 0, 0
    local pref_ok, suff_start = false, false
    for i = 1, #s do
        if s:sub(i, i):match("%d") then pref_ok = true end
        if s:sub(i, i) == ']' and not suff_start then
            suff_start = true
            bak = lvl
        end
        if (pref_ok and s:sub(i, i) == '[') or (not pref_ok and s:sub(i, i) == ']') then return end
        if suff_start and s:sub(i, i) ~= ']' then return end
        if s:sub(i, i) == '[' then lvl = lvl + 1 end
        if s:sub(i, i) == ']' then bak = bak - 1 end
    end
    if bak ~= 0 or not suff_start then return end
    local num = tonumber(s:sub(lvl + 1, #s - lvl))
    if num < -999 or num > 999 then return end
    return Number(num, lvl)
end

--[[
Operations are classes that have the following fields:
execute - function that executes the operation, and returns the label of the next operation to be executed, or nil
]]

Walk = Class {}

local function walk_check(t)
    if #t > 3 then return end
    if #t == 1 then return Walk() end
    local nums, alps = 0, 0
    for i = 2, #t do
        if t[i]:match("%a+") ~= t[i] and not Number.create(t[i]) then
            return
        else
            nums = nums + (Number.create(t[i]) and 1 or 0)
            alps = alps + (t[i]:match("%a+") == t[i] and 1 or 0)
        end
    end
    if nums > 1 or alps > 1 then return end
    local w = Walk()
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    for i = 2, #t do
        if Number.create(t[i]) then
            w.x = Number.create(t[i])
            if w.x.indir == 0 and w.x.num <= 0 then
                return
            end
        else
            if not accepted[t[i]] then
                return
            else
                w.dir = accepted[t[i]]
            end
        end
    end
    return w
end

function Walk.create(t)
    return walk_check(t) or "Wrong 'walk' parameters"
end

function Walk:execute()
    if not self.x then StepManager:walk(nil, self.dir) return end
    local y = self.x:evaluate()
    -- invalid! is an invalid label (because of the '!')
    if not y or y <= 0 then return "invalid!" end
    StepManager:walk(y, self.dir)
end

Turn = Class {
    init = function(self, dir)
        self.dir = dir
    end,
    execute = function(self)
        if self.dir == "counter" or self.dir == "clock" then
            StepManager[self.dir](StepManager)
        else
            StepManager:turn(self.dir)
        end
    end
}

local function turn_check(t)
    if #t ~= 2 then return end
    local accepted = {counter = "counter", clock = "clock", north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    if not accepted[t[2]] then return end
    return Turn(accepted[t[2]])
end

function Turn.create(t)
    return turn_check(t) or "Wrong 'turn' parameters"
end


Nop = Class {
    init = function(self) end,
    execute = function(self) end,
    type = "NOP"
}

Jmp = Class {
    init = function(self, nxt) self.nxt = nxt end,
    execute = function(self) return self.nxt end,
    type = "JMP"
}

-- Used by all OP dst val commands
local function dst_val_check(t)
    if #t ~= 3 then return end
    if not Number.create(t[2]) or not Number.create(t[3]) then return end
    local dst = Number.create(t[2])
    local val = Number.create(t[3])
    if dst.indir == 0 and (dst.num < 0 or dst.num >= Util.findId("memory").slots) then return end
    return dst, val
end

-- Mov --
Mov = Class {}

function Mov.create(t)
    local m = Mov()
    m.dst, m.val = dst_val_check(t)
    if m.dst and m.val then return m end
    return "Incorrect 'mov' parameters"
end

function Mov:execute()
    local dst = self.dst:evaluate()
    local val = self.val:evaluate()
    if not dst or not val then return "invalid!" end
    local mem = Util.findId("memory")
    if not mem:set(dst, val) then return "invalid!" end
end

-- Limits the values in the range -999 .. 999, wraping automatically
local function mod(val)
    val = val + 999
    if val < 0 then val = 999 - val end
    val = val % 1999
    return val - 999
end

-- Add --
Add = Class {}

function Add.create(t)
    local a = Add()
    a.dst, a.val = dst_val_check(t)
    if a.dst and a.val then return a end
    return "Incorrect 'add' parameters"
end

function Add:execute()
    local dst = self.dst:evaluate()
    local val = self.val:evaluate()
    if not dst or not val then return "invalid!" end
    local mem = Util.findId("memory")
    local prev = mem:get(dst)
    if prev and mem:set(dst, mod(prev + val)) then return end
    return "invalid!"
end

-- Sub --
Sub = Class {}

function Sub.create(t)
    local a = Sub()
    a.dst, a.val = dst_val_check(t)
    if a.dst and a.val then return a end
    return "Incorrect 'sub' parameters"
end

function Sub:execute()
    local dst = self.dst:evaluate()
    local val = self.val:evaluate()
    if not dst or not val then return "invalid!" end
    local mem = Util.findId("memory")
    local prev = mem:get(dst)
    if prev and mem:set(dst, mod(prev - val)) then return end
    return "invalid!"
end



function op.read(t)
    if #t == 0 then return Nop() end
    if t[1] == 'walk' then
        return Walk.create(t)
    elseif t[1] == 'turn' then
        return Turn.create(t)
    elseif t[1] == 'nop' then
        if #t ~= 1 then return "Incorrect # of 'nop' parameters"  end
        return Nop()
    elseif t[1] == 'jmp' then
        if #t ~= 2 then return "Incorrect # of 'jmp' parameters" end
        return Jmp(t[2])
    elseif t[1] == 'mov' then
        return Mov.create(t)
    elseif t[1] == 'add' then
        return Add.create(t)
    end
end

return op
