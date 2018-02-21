--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

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


-- Returns a new Number created from string s, or nil or a string error if it is invalid
function Number.create(s, rnms, is_register)
    if #s == 1 and not s:match("%d") and is_register and rnms[s] then return Number(rnms[s], 0) end
    if #s == 1 and not s:match("%d") and s:byte() >= 32 and s:byte() <= 126 then return Number(s:byte(), 0) end
    if not s:match("[%[%]]") and is_register and rnms[s] then return valid_num(rnms[s]) and Number(rnms[s], 0) end
    if not s:match("[%[%]]") then return valid_num(tonumber(s)) and Number(tonumber(s), 0) end
    if s:match("[%[%]0-9a-zA-Z]+") ~= s then return nil end
    local lvl, bak = 0, 0
    local pref_ok, suff_start = false, false
    for i = 1, #s do
        if s:sub(i, i):match("[^%[%]]") then pref_ok = true end
        if s:sub(i, i) == ']' and not suff_start then
            suff_start = true
            bak = lvl
        end
        if (pref_ok and s:sub(i, i) == '[') or (not pref_ok and s:sub(i, i) == ']') then return 'brackets wrong' end
        if suff_start and s:sub(i, i) ~= ']' then return "brackets wrong" end
        if s:sub(i, i) == '[' then lvl = lvl + 1 end
        if s:sub(i, i) == ']' then bak = bak - 1 end
    end
    if bak ~= 0 or not suff_start then return "brackets wrong"  end
    local nums = s:sub(lvl + 1, #s - lvl)
    local num = nil
    if nums:match("%a") then
        num = rnms[nums]
    else
        num = tonumber(nums)
    end
    if not num or num < -999 or num > 999 then return nil end
    if lvl > 0 and (num < 0 or num >= Util.findId('memory').slots) then return "invalid register on number" end
    return Number(num, lvl)
end

--[[
Operations are classes that have the following fields:
execute - function that executes the operation, and returns the label of the next operation to be executed, or nil
]]

Walk = Class {}

function Walk.create(t, rnms)
    if #t > 3 then return end
    if #t == 1 then return Walk() end
    local nums, alps = 0, 0
    for i = 2, #t do
        if t[i]:match("%a+") ~= t[i] and type(Number.create(t[i], rnms)) ~= 'table' then
            return
        else
            if type(Number.create(t[i], rnms)) == 'table' then
                nums = nums + 1
            else
                alps = alps + 1
            end
        end
    end
    if nums > 1 or alps > 1 then return end
    local w = Walk()
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    for i = 2, #t do
        if type(Number.create(t[i], rnms)) == 'table' then
            w.x = Number.create(t[i], rnms)
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

function Walk:execute()
    if self.dir then StepManager.turn(self.dir) end
    if not self.x then StepManager.walk(nil) return end
    local y = self.x:evaluate()
    if type(y) ~= 'number' then return y end
    if y < 0 then return "Trying to walk " .. y .. " steps" end
    if y > 0 then
        StepManager.walk(y)
    end
end

Turn = Class {
    init = function(self, dir)
        self.dir = dir
    end,
    execute = function(self)
        if self.dir == "counter" or self.dir == "clock" then
            StepManager[self.dir](StepManager)
        else
            StepManager.turn(self.dir)
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

function Turn.create(t, rnms)
    return turn_check(t)
end


Nop = Class {
    init = function(self) end,
    execute = function(self) end,
    type = "NOP"
}

--==========================--
--       LABEL              --
--==========================--
Label = Class{}

-- check wheter s is a valid label, and in that case returns it
function Label.create(s, rnms)
    local l = Label()
    local num = Number.create(s, rnms)
    if type(num) == 'table' and num.indir > 0 then l.lab = num
    elseif s:match("%w+") == s then l.lab = s
    else return "Invalid label" end
    return l
end

function Label:evaluate()
    if type(self.lab) == 'string' then return self.lab end
    return tostring(self.lab:evaluate()) -- error or actual number
end

-- Jmp --
Jmp = Class {
    init = function(self, lab) self.lab = lab end
}

function Jmp.create(t, rnms)
    if #t ~= 2 then return end
    local l = Label.create(t[2], rnms)
    if type(l) ~= 'table' then return l end
    return Jmp(l)
end

function Jmp:execute()
    local l = self.lab:evaluate()
    return l, "Tried to access invalid label '" .. l .. "'"
end

-- checks whether s is a valid register, and in that case returns it
local function valid_register(s, rnms)
    local v = Number.create(s, rnms, true)
    if type(v) ~= 'table' then return v end
    if v.indir == 0 and (v.num < 0 or v.num >= Util.findId("memory").slots) then return "Invalid register" end
    return v
end

-- Mov --
Mov = Class {}

function Mov.create(t, rnms)
    if #t ~= 3 then return end
    local m = Mov()
    m.val, m.dst = Number.create(t[2], rnms), valid_register(t[3], rnms)
    if type(m.val) ~= 'table' then return m.val end
    if type(m.dst) ~= 'table' then return m.dst end
    return m
end

function Mov:execute()
    local dst = self.dst:evaluate()
    local val = self.val:evaluate()
    if type(dst) ~= 'number' then return dst end
    if type(val) ~= 'number' then return val end
    return Util.findId("memory"):set(dst, val)
end

-- Limits the values in the range -999 .. 999, wrapping automatically
local function mod(val)
    if val > 999 then
        val = -999 + ((val - 1000) % 1999)
    elseif val < -999 then
        val = 999 - ((-1000 - val) % 1999)
    end
    return val
end



--=============================--
--    UTILS FOR ADD/SUB        --
--=============================--
local function add_sub_create(obj, t, rnms)
    if #t ~= 4 then return nil end
    obj.val1, obj.val2, obj.dst = Number.create(t[2], rnms), Number.create(t[3], rnms), valid_register(t[4], rnms)
    if type(obj.val1) ~= 'table' then return obj.val1 end
    if type(obj.val2) ~= 'table' then return obj.val2 end
    if type(obj.dst) ~= 'table' then return obj.dst end
    return obj
end

local function add_func(a, b) return mod(a + b) end
local function sub_func(a, b) return mod(a - b) end

local function add_sub_execute(obj, func)
    local val1, val2, dst = obj.val1:evaluate(), obj.val2:evaluate(), obj.dst:evaluate()
    if type(val1) ~= 'number' then return val1 end
    if type(val2) ~= 'number' then return val2 end
    if type(dst) ~= 'number' then return dst end
    local mem = Util.findId('memory')
    return mem:set(dst, func(val1, val2))
end

-- Add --
Add = Class {}

function Add.create(t, rnms)
    return add_sub_create(Add(), t, rnms)
end

function Add:execute()
    return add_sub_execute(self, add_func)
end

-- Sub --
Sub = Class {}

function Sub.create(t, rnms)
    return add_sub_create(Sub(), t, rnms)
end

function Sub:execute()
    return add_sub_execute(self, sub_func)
end

-- init for jgt jlt jge jle
local function vvl_init(self, v1, v2, lab)
    self.v1 = v1
    self.v2 = v2
    self.lab = lab
end

local function vvl_execute(self)
    local a, b = self.v1:evaluate(), self.v2:evaluate()
    if type(a) ~= 'number' then return a end
    if type(b) ~= 'number' then return b end
    if self.comp(a, b) then return self.lab:evaluate() end
end

-- Used by all val1 val2 lab operations
local function vvl_check(t, class, rnms)
    if #t ~= 4 then return end
    local v1, v2, lab = Number.create(t[2], rnms), Number.create(t[3], rnms), Label.create(t[4], rnms)
    if type(v1) ~= 'table' then return v1 end
    if type(v2) ~= 'table' then return v2 end
    if type(lab) ~= 'table' then return lab end
    return class(v1, v2, lab)
end

-- Jgt - Jump greater than --
Jgt = Class {init = vvl_init, comp = function(a, b) return a > b end, execute = vvl_execute}
-- Jge - Jump greater or equal --
Jge = Class {init = vvl_init, comp = function(a, b) return a >= b end, execute = vvl_execute}
-- Jlt - Jump lesser than --
Jlt = Class {init = vvl_init, comp = function(a, b) return a < b end, execute = vvl_execute}
-- Jle - Jump lesser or equal --
Jle = Class {init = vvl_init, comp = function(a, b) return a <= b end, execute = vvl_execute}
-- Jeq - Jump equal --
Jeq = Class {init = vvl_init, comp = function(a, b) return a == b end, execute = vvl_execute}
-- Jne - Jump not equal --
Jne = Class {init = vvl_init, comp = function(a, b) return a ~= b end, execute = vvl_execute}

-- Read --
Read = Class{}

function Read:create(t, rnms)
    if #t > 3 or #t <= 1 then return end
    local obj = self()
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    if t[3] and not accepted[t[3]] then return end
    obj.reg, obj.dir = valid_register(t[2], rnms), accepted[t[3]]
    if type(obj.reg) ~= 'table' then return obj.reg end
    return obj
end

function Read:execute()
    if self.dir then StepManager.turn(self.dir) end
    local console = ROOM:next_block()
    if not console or console.tp ~= "console" then return "Trying to read from non-console" end
    local nx = console:input()
    if not nx then return "No input on console" end
    if type(nx) ~= 'number' then return nx end
    return Util.findId("memory"):set(self.reg:evaluate(), nx)
end

-- WalkC --
WalkC = Class{create = Read.create}

function WalkC:execute()
    if self.dir then StepManager.turn(self.dir) end
    StepManager.walkc(self, 0)
end

function WalkC:finishWalk(count)
    local err = Util.findId('memory'):set(self.reg:evaluate(), count)
    if err then StepManager.stop("Code error!", "Your code got a runtime error (0x" .. love.math.random(10000, 99999) .. "). Error message:\n\n\"" .. err .. "\"\n\nFor this reason, subject #" .. Util.findId("info_tab").dead .. " \"" .. ROOM.bot.name .. "\" is no longer working and will be sacrificed and replaced.") end
end

-- Write --
Write = Class{}

function Write:create(t, rnms)
    if #t > 3 or #t <= 1 then return end
    local obj = self()
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    if t[3] and not accepted[t[3]] then return end
    obj.num, obj.dir = Number.create(t[2], rnms), accepted[t[3]]
    if type(obj.num) ~= 'table' then return obj.num end
    return obj
end

function Write:execute()
    if self.dir then StepManager.turn(self.dir) end
    local console = ROOM:next_block()
    if not console or console.tp ~= "console" then return "Trying to write to non-console" end
    local val = self.num:evaluate()
    if type(val) ~= 'number' then return val end
    return console:write(val)
end

local DIR_CONV = {
    north = NORTH, up = NORTH,
    east = EAST, right = EAST,
    south = SOUTH, down = SOUTH,
    west = WEST, left = WEST
}

-- Pickup
Pickup = Class{
    init = Turn.init
}

function Pickup.create(t, rnms)
    if #t > 2 then return end
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    if t[2] and not accepted[t[2]] then return end
    return Pickup(accepted[t[2]])
end

function Pickup:execute()
    local _n = ROOM:next_block(DIR_CONV[self.dir])
    if not _n or not _n.pickable then return "Unpickable object" end
    if self.dir then
        StepManager.turn(self.dir)
    end
    return StepManager.pickup()
end

Drop = Class{
    init = Turn.init
}

function Drop.create(t, rnms)
    if #t > 2 then return end
    local accepted = {north = "north", west = "west", east = "east", south = "south",
    up = "north", down = "south", left = "west", right = "east"}
    if t[2] and not accepted[t[2]] then return end
    return Drop(accepted[t[2]])
end

function Drop:execute()
    if not ROOM.bot.inv then return "There is nothing left to drop but my self esteem" end
    if self.dir then
        StepManager.turn(self.dir)
    end
    return StepManager.drop()
end

function op.read(t, rnms)
    if #t == 0 then return Nop(rnms)
    elseif t[1] == 'walk' then
        return Walk.create(t, rnms)
    elseif t[1] == 'turn' then
        return Turn.create(t, rnms)
    elseif t[1] == 'nop' then
        if #t == 1 then return Nop(rnms) end
    elseif t[1] == 'jmp' then
        return Jmp.create(t, rnms)
    elseif t[1] == 'mov' then
        return Mov.create(t, rnms)
    elseif t[1] == 'add' then
        return Add.create(t, rnms)
    elseif t[1] == 'sub' then
        return Sub.create(t, rnms)
    elseif t[1] == 'jgt' then
        return vvl_check(t, Jgt, rnms)
    elseif t[1] == 'jge' then
        return vvl_check(t, Jge, rnms)
    elseif t[1] == 'jlt' then
        return vvl_check(t, Jlt, rnms)
    elseif t[1] == 'jle' then
        return vvl_check(t, Jle, rnms)
    elseif t[1] == 'jeq' then
        return vvl_check(t, Jeq, rnms)
    elseif t[1] == 'jne' then
        return vvl_check(t, Jne, rnms)
    elseif t[1] == 'read' then
        return Read:create(t, rnms)
    elseif t[1] == 'write' then
        return Write:create(t, rnms)
    elseif t[1] == 'pickup' then
        return Pickup.create(t, rnms)
    elseif t[1] == 'drop' then
        return Drop.create(t, rnms)
    elseif t[1] == 'walkc' then
        return WalkC:create(t, rnms)
    else return "Unknown command " .. t[1] end
end

return op
