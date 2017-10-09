name = "Would you kindly?"
-- Puzzle number
n = 'F.1'

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

function on_start(room)
    if not _G.require('classes.lore_manager').puzzle_done.franz1 then
        room.bot.name = 'Diego'
        room.bot.traits = {'Good Friend', 'Suspicious'}
    end
    local ct = _G.Util.findId('code_tab')
    ct.lock = ct.lock + 1 -- will reset automatically
    ct.term.lines = {"walk right"} -- fixed text
    ct.fast_b.img = _G.BUTS_IMG.fast_blocked
    ct.superfast_b.img = _G.BUTS_IMG.superfast_blocked
    ct.pause_b.img = _G.BUTS_IMG.pause_blocked
    ct.stop_b.img = _G.BUTS_IMG.stop_blocked
    _G.StepManager.only_play_button = true
    _G.ROOM.block_bot_messages = true
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
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = "Good grief",
            clr = _G.Color.blue()
        })
end
