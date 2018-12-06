--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Leaderboards = Class {
    __includes = {Tab}
}

function Leaderboards:init(eps, dy)
    assert(USING_STEAM)
    Tab.init(self, eps, dy)

    self.name = "leaderboards"

    self.image = BUTS_IMG.achievements

    self.loaded_puzzle = nil
end

function Leaderboards:preload()
    self:activate()
end

function Leaderboards:activate()
    if self.loaded_puzzle == ROOM.puzzle.id then return end
    local id = ROOM.puzzle.id
    self.state = 'loading'
    self.loaded_puzzle = id

    Steam.userStats.findOrCreateLeaderboard(id .. '_linecount', 'Ascending', 'Numeric', function(info, err)
        if err or info == nil then
            self.state = 'failed'
            return
        end
        Steam.userStats.downloadLeaderboardEntries(info.steamLeaderboard, "Global", 1, 10000, function(results, err2)
            if err2 or results == nil then
                self.state = 'failed'
                return
            end
            for i, r in ipairs(results) do
                results[i] = r.score
            end
            self:showScores(results)
        end)
    end)
end

-- scores is a vector of integers, each the line count for a user in this puzzle
function Leaderboards:showScores(scores)
    self.state = 'loaded'
    self.scores = scores
end

function Leaderboards:deactivate()
end

function Leaderboards:update(dt)
end

function Leaderboards:draw()
    if self.state == 'loading' then
        love.graphics.print('loading', self.pos.x, self.pos.y)
    elseif self.state == 'failed' then
        love.graphics.print('failed', self.pos.x, self.pos.y)
    else
        for i, s in ipairs(self.scores) do
            love.graphics.print('Score: ' .. s, self.pos.x, self.pos.y + 20 * (i - 1))
        end
    end
end


return Leaderboards