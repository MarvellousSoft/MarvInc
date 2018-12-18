--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Leaderboards = require "classes.leaderboards"
local ScoreManager = require "classes.score_manager"

local state = {}

local _switch
local _lb_line
local _lb_cycles

function state:enter(previous, puzzle_id)
    local x, y = 230, 200
    _lb_line = Leaderboards.create(x, y, "LINES", true)
    ScoreManager.populateLeaderboard(_lb_line, puzzle_id, 'linecount')
    _lb_cycles = Leaderboards.create(x + _lb_line.w + 160, y, "CYCLES", true)
    ScoreManager.populateLeaderboard(_lb_cycles, puzzle_id, 'cycles')
    _switch = false
end

function state:update(dt)
    Util.updateTimers(dt)
    if _switch then
        Gamestate.pop()
    end
end

function state:draw()

    Draw.allTables()
    love.graphics.setColor(20, 20, 20, 230)
    love.graphics.rectangle("fill", 0, 0, W, H)
    _lb_line:draw()
    _lb_cycles:draw()

end

function state:mousepressed(x, y, button, isTouch)
    _switch = true
end

function state:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        _switch = true
    end
end

function state:leave()
    _lb_line:kill()
    _lb_line:kill()
end

return state
