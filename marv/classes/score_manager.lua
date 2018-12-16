local StepManager = require "classes.step_manager"
local Leaderboards = require "classes.leaderboards"

local sm = {}

function sm.uploadCompletedStats(puzzle)
    local line_count = Util.findId('code_tab'):countLines()
    local steps = StepManager.ic
    -- maybe register accesses total instead of just count?
    local reg_used = Util.findId('code_tab').memory:countUsed()
    print('Stats for ' .. puzzle.id .. ': Lines=' .. line_count .. ' Steps=' .. steps .. ' Register used=' .. reg_used)
    if not USING_STEAM then return end
    if line_count <= 0 then return end
    local id = ROOM.puzzle.id
    Steam.userStats.findOrCreateLeaderboard(id .. '_linecount', "Ascending", "Numeric", function (info, err)
        if err or info == nil then return end
        Steam.userStats.uploadLeaderboardScore(info.steamLeaderboard, "KeepBest", line_count, nil, function(_, err2)
            if err2 then return end
            print('Stats uploaded to leaderboard: completed ' .. id .. ' with ' .. line_count .. ' lines')
            Steam.userStats.downloadLeaderboardEntries(info.steamLeaderboard, "Global", 1, 10000, function(results, err3)
                if err3 or results == nil then return end
                local pop = Util.findId("popup")
                if not pop then return end
                pop:translate(-260,0)
                for i, r in ipairs(results) do
                    results[i] = r.score
                end
                Leaderboards.create(710, 250, "LINES", results, line_count)
            end)
        end)
    end)
end


return sm