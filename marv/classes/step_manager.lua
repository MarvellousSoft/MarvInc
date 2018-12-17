--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Parser = require "classes.interpreter.parser"

-- StepManager
--[[ Handles play/stop/etc. button presses and also commands from the code (walk,pickup,etc.)
The execution of code is always on one of four states:
stopped - code not running, code not even 'compiled' or initialized
playing - code running automatically (a turn every x seconds)
paused - code is executing, but turns do not happend automatically

It always starts in stopped, and changes according to the functions called (play, fast, superfast, step, stop, pause)
play, fast, superfast - If code is stopped, compiles it and starts it. If it is paused, starts doing turns automatically. The state always change to playing after these calls.
step - similar to above, but only one turn is executed, and the state is changed to paused.
pause - If playing, stops turns from happening automatically, and changes state to paused. Otherwise does nothing.
stop - Stops turns from happening automatically, clears memory, and changes the state to stopped.

]]


local sm = {
    -- instruction counter
    ic = 0,
    timer = Timer.new(),

    state =  "stopped",

    -- command to be executed instead of next instructions
    -- (used by instructions that take more than one turn (walk))
    cmd = nil,

    -- how long a turn takes
    delay = 1,

    -- 0 is not running
    -- 1 is normal speed
    -- 2 is fast
    -- 3 is very fast
    how_fast = 0,
    speeds = {.5, .05, .001, .000001, [0] = 0}
}

-- BUTTONS/STATE COMMANDS

local speed_4_frames = 0

local function stepCallback()
    sm.ic = sm.ic + 1
    if sm.how_fast ~= 4 then
        SFX.click:play()
    end

    -- deletes 1-turn stuff (lasers)
    ROOM:deleteEphemeral()

    Signal.emit(SIGEND, sm.ic)

    if not sm.code then
        print "should not be here"
        return
    end

    local code_over = false

    if sm.cmd then
        local func = sm.cmd
        sm.cmd = nil
        func()
    else
        local ret = sm.code:step()
        if ret == 'halt' then
            if not sm.cmd and sm.state ~= 'stopped' then
                -- in this case the code finished normally, but didn't succeed
                Util.findId("code_tab"):showLine(#sm.code.ops + 1)
                code_over = true
            end
        elseif ret == 'error' then
            -- state will be changed automatically by the function call
            -- Creates 1-turn stuff (lasers) (after action)
            ROOM:createEphemeral()
            return
        end
    end

    if not sm.cmd then
        -- highlight next pending line, check if we hit a breakpoint
        local next_line = sm.code.real_line[sm.code.cur]
        local code_tab = Util.findId("code_tab")
        code_tab:showLine(next_line)
        if code_tab:isBreakPoint(next_line) then
            sm.pause()
        end
    end

    -- Creates 1-turn stuff (lasers) (after action)
    ROOM:createEphemeral()

    ROOM.bot:dieIfStay(ROOM.grid_obj)

    if ROOM.puzzle:manage_objectives() or sm.state ~= 'playing' then return end
    if code_over then
        sm.stop("code_over")
        return
    end

    if sm.how_fast == 4 then
        speed_4_frames = speed_4_frames + 1
        if speed_4_frames >= 10 then
            speed_4_frames = 0
            sm.timer:after(sm.delay, stepCallback)
        else
            stepCallback()
        end
    else
        sm.timer:after(sm.delay, stepCallback)
    end
end

-- Plays a set of instructions until step can no longer parse.
local function doPlay(how_fast)
    if PopManager.pop then return end
    if not ROOM:connected() then
        SFX.buzz:play()
        return
    end

    if sm.state == 'playing' then sm.timer:clear() end

    if sm.state == 'waiting' then sm.stop(nil, nil, nil, how_fast) return end
    if sm.state == 'stopped' then
        sm.ic = 0
        sm.code = Parser.parseCode()
        if type(sm.code) ~= "table" then
            sm.code = nil
            SFX.buzz:play()
            return
        end
        sm.code:start()

    end

    sm.state = how_fast == 0 and 'paused' or 'playing'
    sm.how_fast = how_fast
    if how_fast == 4 then
        speed_4_frames = 0
    end
    sm.delay = sm.speeds[how_fast]
    sm.timer:after(sm.delay, stepCallback)
end

function sm.play()
    doPlay(1)
end

function sm.fast()
    if sm.only_play_button then
        SFX.buzz:play()
    else
        doPlay(2)
    end
end

function sm.superfast()
    if sm.only_play_button then
        SFX.buzz:play()
    else
        doPlay(3)
    end
end

function sm.increase()
    if PopManager.pop then return end
    if sm.only_play_button then
        SFX.buzz:play()
        return
    end
    if sm.how_fast == 2 then sm.superfast()
    elseif sm.how_fast == 1 then sm.fast()
    elseif sm.how_fast == 0 then sm.play() end
end

function sm.decrease()
    if PopManager.pop then return end
    if sm.only_play_button then
        SFX.buzz:play()
        return
    end
    if sm.how_fast == 3 then sm.fast()
    elseif sm.how_fast == 2 then sm.play()
    elseif sm.how_fast == 1 then sm.pause() end
end

function sm.step()
    if PopManager.pop then return end
    if sm.only_play_button then
        SFX.buzz:play()
        return
    end
    doPlay(0)
end

function sm.pause()
    if PopManager.pop then return end
    if not ROOM:connected() or sm.only_play_button then
        SFX.buzz:play()
        return
    end

    if sm.state == 'playing' then
        sm.timer:clear()
        sm.how_fast = 0
        sm.state = 'paused'
    end
end

function sm.stop(fail_title, fail_text, fail_button, replay_speed, show_popup, test_i, megafast, force)
    if PopManager.pop then return end
    if not force and (sm.state == 'stopped' or not ROOM:connected() or sm.only_play_button) then
        SFX.buzz:play()
        return
    end

    sm.clear(true)
    ROOM:kill(fail_title == 'no kill')

    -- display popup
    local callback = function()
        sm.clear(false)
        -- Just to be sure we aren't forgetting to clean anything
        -- And this should be a pretty fast procedure
        local term = Util.findId('code_tab').term
        local bk, breakpoints = term.backups, term.breakpoints -- preserve history and breakpoints
        ROOM:connect(ROOM.puzzle_id, false, ROOM.is_custom, test_i, megafast)
        if replay_speed then doPlay(replay_speed) end
        term.backups, term.breakpoints = bk, breakpoints
    end

    if show_popup == false or fail_title == 'no kill' then
        callback()
        return
    end

    local n = Util.findId("info_tab").dead - 1

    --Creating failed popup
    local title, text
    if fail_title and FAILED_POPUP_MESSAGES[fail_title] then
      title = FAILED_POPUP_MESSAGES[fail_title].title
      text = Util.randomElement(FAILED_POPUP_MESSAGES[fail_title].sentences)
    else
      if not fail_title then
        title = "Bot #"..n.." has been destroyed!"
      else
        title = fail_title
      end
      if not fail_text then
        text = "Communications with test subject #"..n.." \""..ROOM.bot.name.."\" have been lost."
      else
        text = fail_text
      end
    end

    local button = Util.randomElement(FAILED_POPUP_BUTTON_TEXT)

    SFX.fail:stop()
    SFX.fail:play()
    PopManager.newFailed(title, text,
        {
            func = callback,
            text = button,
            clr = Color.blue()
        },
        ROOM.bot, n)

end

function sm.clear(show_code_state)
    if sm.state == 'playing' then sm.timer:clear() end
    if sm.code then
        sm.code:stop(show_code_state)
        if not show_code_state then
            sm.code = nil
        end
    end
    sm.cmd = nil
    sm.state = 'stopped'
    sm.how_fast = 0
    if not show_code_state then
        Util.findId("code_tab").memory:reset()
    end
end

-- CODE COMMANDS

-- Assumes x > 0 or x == nil
function sm.walk(x)
    sm.cmd = function() sm.walk(x and x - 1) end
    ROOM:walk()
    if (not x or x > 1) and ROOM:blocked(nil, true) then end
    if x == 1 then
        sm.cmd = nil
    elseif not x and ROOM:blocked() then
        sm.cmd = nil
    end
end

function sm.walkc(op, count)
    if not ROOM:blocked() then
        ROOM:walk()
        count = count + 1
    end
    if ROOM:blocked(nil, true) then
        sm.cmd = nil
        op:finishWalk(count)
    else
        sm.cmd = function() sm.walkc(op, count) end
    end
end

function sm.turn(dir)
    ROOM:turn(dir)
    return false
end

function sm.clock()
    ROOM:clock()
    return false
end

function sm.counter()
    ROOM:counter()
    return false
end

function sm.pickup()
    return ROOM:pickup()
end

function sm.drop()
    return ROOM:drop()
end

-- EXTRA

function sm.update(dt)
    sm.timer:update(dt)
end

return sm
