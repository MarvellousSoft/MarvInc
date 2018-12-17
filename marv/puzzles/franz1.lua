--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "Would you kindly?"
-- Puzzle number
n = 'F.1'
test_count = 1

lines_on_terminal = 1
memory_slots = 0

-- Bot
bot = {'b', "EAST"}

-- name, draw background, image
o = {"obst", false, "wall_none"}
k = {'bucket', true, 'bucket', args = {content = 'water'}}
l = {"dead_switch", false, "lava", 0.2, "white", "solid_lava", args = {bucketable = true}}

-- Objective
objective_text = 'Prove your loyalty.'
function objective_checker(room)
    -- this is handled in classes/bot.lua in function kill()
    return false
end

local msg_list = {
    "W-what... What is going on?",
    "Why do I have a splitting headache?",
    "Bzzzt! Robot ready for duty.",
    "WHAT THE F- Bzzzt!",
    "MarvInc, where dreams come true! Bzzz! Shit bro, what the...? Bzzt!",
    "Bro... Is that you? Why am I here?!",
    "Hey man, w-what the shit!? Get me outta here!!",
    "Bzzzt! MarvBots are always eager to please!",
    "AAAAARGH MY HEAD!!!",
    "Is this a prank? What the fuck, man!",
    "Bzzzt! Join MarvInc today and make the world a better place!",
    "Bzzzt! MOTHERFUCKER, WHAT THE SHIT ARE YOU DOING?!",
    "I know it's you, you fucking son of a bitch!",
    "Bzzzt! The new MarvInc personal robots are now available! For only $999,99!",
    "Bzzzt! My head... It's hurting so fucking much... I... I can't take it...",
    "Bzzzt! Get yours now! Call 1-800-MARVINC and reserve yours!",
    "Bzzzt! W-what...? W-w-why?!",
    "C'mon man, I'll do what you want, just get me outta here...",
    "Whatever you want, I'll do it...",
    "Bzzzt! The new MarvInc personal robots! Each with a unique personality! Call now and guarantee yours!",
    "Bzzzt! J-Just... Just kill me bro. What the fuck? My head... It just hurts so much...",
    "Bzzzt! Be it household, industrial or even military! The new MarvBots are just so handy!",
    "Bzzzt! Kill me... End this b-bro...",
    "...",
    "Bzzzt!",
    "MarvBots, the latest in MarvInc technology! Find yours at your local MarvStore!",
    "I aim to please! Please give me a command. :)",
    "MarvBot standing by."
}

local cur_msg = 0
local function rnd_delay() return random(2, 6) end

local handle = nil

function on_start(room)
    if not _G.require('classes.lore_manager').puzzle_done.franz1 then
        room.bot.name = 'Diego'
        room.bot.traits = {'Good Friend', 'Suspicious'}
    else
        msg_list = {}
    end
    local ct = _G.Util.findId('code_tab')
    ct.lock = ct.lock + 1 -- will reset automatically
    ct.term.lines = {"walk right"} -- fixed text
    ct.fast_b:block(_G.BUTS_IMG.fast_blocked)
    ct.superfast_b:block(_G.BUTS_IMG.superfast_blocked)
    ct.pause_b:block(_G.BUTS_IMG.pause_blocked)
    ct.stop_b:block(_G.BUTS_IMG.stop_blocked)
    _G.StepManager.only_play_button = true
    _G.ROOM.block_bot_messages = true
    handle = _G.MAIN_TIMER:after(rnd_delay(), function(self)
        if _G.ROOM.puzzle_id ~= 'franz1' or _G.require('classes.lore_manager').puzzle_done.franz1 then return end
        cur_msg = cur_msg + 1
        if cur_msg > #msg_list then cur_msg = #msg_list end
        _G.Signal.emit("new_bot_message", msg_list[cur_msg], 120)
        handle = _G.MAIN_TIMER:after(rnd_delay() + (cur_msg == #msg_list and 10 or 0), self)
    end)
end

function on_end(room)
    _G.MAIN_TIMER:cancel(handle)
end


grid_obj =  "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooob.............looo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"..
            "ooooooooooooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

function first_completed()
    local et = _G.Util.findId("email_tab")
    for a, b in _G.ipairs(et.email_list) do
        if b.id == 'franz1' then
            _G.require('classes.tabs.email').disableReply(a)
        end
    end
    _G.PopManager.new("A message",
        "You have been warned.",
        _G.CHR_CLR['franz'], {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " good grief ",
            clr = _G.Color.blue()
        })
end
