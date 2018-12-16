--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Decryptor"
-- Puzzle number
n = "???"
test_count = 1

lines_on_terminal = 50
memory_slots = 30

-- Bot
bot = {'b', "WEST"}

local ans = {}

local function add(v, x, p, m)
    x = x % m
    _G.table.insert(v, x)
    _G.table.insert(v, p)
    _G.table.insert(v, m)
    a = 1
    for i = 1, p do
        a = (a * x) % m
    end
    _G.table.insert(ans, a)
end
local function rnd(l, r) return random(l, r) end
local function create_vec()
    local v = {}
    add(v, 3, 4, 10)
    add(v, 3, 7, 9)
    add(v, 19, 3, 20)
    add(v, 4, 15, 17)
    add(v, 7, 4, 10)
    for i = 1, 7 do
        add(v, rnd(0, 10), rnd(0, 5), rnd(2, 10))
    end
    for i = 1, 4 do
        add(v, rnd(0, 20), rnd(0, 20), rnd(2, 20))
    end
    add(v, 1, 7, 2)
    add(v, 0, 2, 7)
    add(v, 0, 0, 7)

    return v
end

-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = {vec = create_vec, show_nums = 10}, dir = "east"}
d = {"console", false, "console", "blue", args = {vec = 'output', show_nums = 10}, dir = "west"}

-- console objects
local gr, bl

local function rnd(l, r)
    if l then
        return random() * (r - l) + l
    else
        return random()
    end
end

local function randomize_floor()
    local p = rnd()
    for i = 1, _G.ROWS do
        for j = 1, _G.COLS do
            _G.ROOM.grid_floor[j][i] = rnd() <= p and 'white_floor' or 'black_floor'
        end
    end
end

local msg_list = {
    "Breach detected",
    "Please reinitialize OS",
    "##!@#!@#$@#%",
    "WE'RE HERE TO HELP",
    "Please hear our message",
    "Finish this puzzle",
}

-- handles
local msg_h, static_h = nil, nil

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, ROWS do
        for j = 1, COLS do
            local o = room.grid_obj[j][i]
            if o and o.tp == 'console' then
                if #o.out > 0 then
                    gr = o
                else
                    bl = o
                end
            end
        end
    end
    -- configure bot messages
    _G.ROOM.block_bot_messages = true
    local cur = 1
    msg_h = _G.MAIN_TIMER:after(30, function(self)
        if _G.ROOM.puzzle_id ~= 'spam' then return end
        _G.Signal.emit("new_bot_message", msg_list[cur])
        cur = cur + 1
        if cur > #msg_list then cur = 3 end
        msg_h = _G.MAIN_TIMER:after(rnd(45, 120), self)
    end)
    -- configure static
    local base_wait = 2
    static_h = _G.MAIN_TIMER:after(base_wait, function(self)
        if _G.ROOM.puzzle_id ~= 'spam' then return end
        randomize_floor()
        base_wait = base_wait + 2
        _G.FX.quick_static(rnd(0.05, 0.15), function() static_h = _G.MAIN_TIMER:after(rnd() < .05 and .1 or base_wait + rnd(3, 10), self) end)
    end)
end

function on_end(room)
    _G.MAIN_TIMER:cancel(msg_h)
    _G.MAIN_TIMER:cancel(static_h)
end

-- Objective
objective_text = [[
Read triples (x, p, m) from the green console. For each triple, write (x ^ p) mod m to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got  "  .. bl.inp[i] .. ".  Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end

extra_info = [[
Example: "3 4 10 3 13 9" should output "1 0"
- 0 ≤ x < m, and 0 ≤ p ≤ 20 and 2 ≤ m ≤ 20.
]]

grid_obj =  "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "........ooooo........"..
            "ooooooooocbdooooooooo"..
            "........ooooo........"..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."..
            "....................."

-- Floor
w = "white_floor"
_G.getfenv()[','] = "black_floor"
r = "red_tile"

grid_floor = "w,ww,wwwww,wwwwwwwwww"..
             "w,ww,wwwww,wwwwwwwwww"..
             "w,ww,w,,,w,w,,,wwwwww"..
             "w,,,,w,www,w,w,wwwwww"..
             "w,ww,w,,ww,w,,,wwwwww"..
             "w,ww,w,www,w,wwwwwwww"..
             "w,ww,w,,,w,w,wwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwww,ww,wwwwww"..
             "wwwwwwwwwww,ww,w,,,,w"..
             "wwwwwwwwwww,ww,w,wwww"..
             "wwwwwwwwwww,ww,w,,,,w"..
             "wwwwwwwwwww,ww,wwww,w"..
             "wwwwwwwwwww,,,,w,,,,w"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    local old_text, new_email
    local et = _G.Util.findId("email_tab")
    local Mail = _G.require('classes.tabs.email')
    for i, e in _G.ipairs(et.email_list) do
        if e.id == 'fergus5_fake' then
            local e2 = Mail.get_raw_email('fergus5', i)
            e2.was_read = e.was_read
            e2.juicy_bump = 0
            e2.alpha = 255
            et.email_list[i] = e2
            old_text = e.text
            new_email = e2
        end
    end
    _G.PopManager.new("Thanks",
        "You've just decrypted the most important email of your life.\n\nFergus",
        _G.CHR_CLR['fergus'], {
            func = function()
                _G.ROOM:disconnect()
                local op = et:openEmail(new_email)
                op.text = _G.Util.stylizeText(old_text, {0, 0, 0, 255})
                local cur_text = old_text
                local txt = new_email.text
                local i = 1
                _G.MAIN_TIMER:every(.03, function()
                    if i > #txt then return false end
                    cur_text = txt:sub(1, i) .. old_text:sub(i + 1, #old_text)
                    op.text = _G.Util.stylizeText(cur_text, {0, 0, 0, 255})
                    i = i + 1
                end)
            end,
            text = " show me ",
            clr = _G.Color.blue()
        })
end
