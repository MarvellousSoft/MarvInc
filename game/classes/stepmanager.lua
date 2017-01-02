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
    speeds = {.5, .05, .001, [0] = 0}
}

-- BUTTONS/STATE COMMANDS

local function stepCallback()
    sm.ic = sm.ic + 1
    SFX.click:play()

    if not sm.code then
        print "should not be here"
        return
    end

    local code_over = false

    if sm.cmd then
        sm.cmd()
    else
        local ret = sm.code:step()
        if ret == 'halt' then
            if not sm.cmd then
                -- in this case the code finished normally, but didn't succeed
                Util.findId("code_tab"):showLine(#sm.code.ops + 1)
                code_over = true
            end
        elseif ret == 'error' then
            -- state will be changed automatically by the function call
            return
        end
    end

    ROOM.puzzle:manage_objectives()
    if sm.state ~= 'playing' then return end
    if code_over then
        local n = Util.findId("info_tab").dead
        local title = "Code not successful"
        local text =
            "Your code finished but the objectives weren't completed. " ..
            "Test subject #"..n.." \""..ROOM.bot.name.."\" had to be sacrificed. " ..
            "Another unit has been dispatched to replace #"..n..".\nA notification has "..
            "been dispatched to HR and this incident shall be added to your personal file."
        local button = "I will be more successful next time"
        sm.stop(title, text, button)
        return
    end
    sm.timer:after(sm.delay, stepCallback)
end

-- Plays a set of instructions until step can no longer parse.
local function doPlay(how_fast)
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
    sm.delay = sm.speeds[how_fast]
    sm.timer:after(sm.delay, stepCallback)
end

function sm.play()
    doPlay(1)
end

function sm.fast()
    doPlay(2)
end

function sm.superfast()
    doPlay(3)
end

function sm.increase()
    if sm.how_fast == 2 then sm.superfast()
    elseif sm.how_fast == 1 then sm.fast()
    elseif sm.how_fast == 0 then sm.play() end
end

function sm.decrease()
    if sm.how_fast == 3 then sm.fast()
    elseif sm.how_fast == 2 then sm.play()
    elseif sm.how_fast == 1 then sm.pause() end
end

function sm.step()
    doPlay(0)
end

function sm.pause()
    if not ROOM:connected() then
        SFX.buzz:play()
        return
    end

    if sm.state == 'playing' then
        sm.timer:clear()
        sm.how_fast = 0
        sm.state = 'paused'
    end
end

function sm.stop(fail_title, fail_text, fail_button, replay_speed, show_popup)
    if not ROOM:connected() then
        SFX.buzz:play()
        return
    end

    sm.clear()
    ROOM:kill()

    -- display popup
    local callback = function()
        -- Just to be sure we aren't forgetting to clean anything
        -- And this should be a pretty fast procedure
        ROOM:connect(ROOM.puzzle_id, false)
        if replay_speed then doPlay(replay_speed) end
    end

    if show_popup == false then
        callback()
        return
    end

    local n = Util.findId("info_tab").dead
    local title = fail_title or "Bot #"..n.." has been destroyed!"
    local text = fail_text or
        ("Communications with test subject #"..n.." \""..ROOM.bot.name.."\" have been "..
        "lost. Another unit has been dispatched to replace #"..n..". A notification has "..
        "been dispatched to HR and this incident shall be added to your personal file.")
    local button = fail_button or "I will be more careful next time"
    SFX.fail:stop()
    SFX.fail:play()
    PopManager.new(title, text,
         Color.red(), {
            func = callback,
            text = button,
            clr = Color.blue()
        })

end

function sm.clear()
    if sm.state == 'stopped' then return end
    if sm.state == 'playing' then sm.timer:clear() end
    if sm.code then
        sm.code:stop()
        sm.code = nil
    end
    sm.state = 'stopped'
    sm.how_fast = 0
    Util.findId("code_tab").memory:reset()
end

-- CODE COMMANDS

-- Assumes x > 0 or x == nil
function sm.walk(x)
    sm.cmd = function() sm.walk(x and x - 1) end
    ROOM:walk()
    if x == 1 then sm.cmd = nil end
    if not x and ROOM:blocked() then
        sm.cmd = nil
    end
end

function sm.walkc(op, count)
    if not ROOM:blocked() then
        ROOM:walk()
        count = count + 1
    end
    if ROOM:blocked() then
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
    ROOM:pickup()
    return false
end

function sm.drop()
    ROOM:drop()
    return false
end

-- EXTRA

function sm.update(dt)
    sm.timer:update(dt)
end

return sm
