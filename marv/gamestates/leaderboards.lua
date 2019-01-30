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
local _name_chart = {
    linecount = 'LINES',
    cycles = 'CYCLES',
}

function state:enter(previous, puzzle_id, metrics)
    local w, h = 350, 480
    local step = W/(#metrics + 1)
    local x, y = step - w/2, H/2 - h/2
    self.leaderboards = {}
    for _,metric in ipairs(metrics) do
        local name = _name_chart[metric] or "METRIC"
        local lb = Leaderboards.create(x, y, w, h, name, true)
        ScoreManager.populateLeaderboard(lb, puzzle_id, metric)
        table.insert(self.leaderboards, lb)
        x = x + step
    end
    _switch = false
end

function state:update(dt)
    for _, l in ipairs(self.leaderboards) do
        l:update(dt)
    end
    Util.updateTimers(dt)
    if _switch then
        Gamestate.pop()
    end
end

function state:draw()

    Draw.allTables()
    love.graphics.setColor(20, 20, 20, 230)
    love.graphics.rectangle("fill", 0, 0, W, H)
    for _,lb in ipairs(self.leaderboards) do
        lb:draw()
    end

end

function state:mousemoved(...)
    for _, l in ipairs(self.leaderboards) do
        l:mouseMoved(...)
    end
end

function state:mousereleased(...)
    for _, l in ipairs(self.leaderboards) do
        l:mouseReleased(...)
    end
end

function state:wheelmoved(...)
    for _, l in ipairs(self.leaderboards) do
        l:mouseScroll(...)
    end
end

function state:mousepressed(x, y, but, ...)
    for _, l in ipairs(self.leaderboards) do
        l:mousePressed(x, y, but, ...)
    end
end

function state:mousereleased(x, y, but, ...)
    local any = false
    for _, l in ipairs(self.leaderboards) do
        any = any or Util.pointInRect(x, y, l)
    end
    if but == 1 and not any then
        _switch = true
    end
end

function state:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        _switch = true
    end
end

function state:leave()
    for _,lb in ipairs(self.leaderboards) do
        lb:kill()
    end
end

return state
