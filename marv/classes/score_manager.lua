local StepManager = require "classes.step_manager"
local Leaderboards = require "classes.leaderboards"

local sm = {}

local steps_vec = {}
local line_count_vec = {}

local function avg(tab, n)
    local sum = 0
    for i = 1, n do
        sum = sum + tab[i]
    end
    return sum / n
end

function sm.getStatsForTest(i)
    steps_vec[i] = StepManager.ic
    line_count_vec[i] = Util.findId('code_tab'):countLines()
end

local function uploadScoreAndShow(id, score, mult, score_type, lb)
    Steam.userStats.findOrCreateLeaderboard(id .. '_' .. score_type, "Ascending", "Numeric", function (info, err)
        if err or info == nil then return lb:gotError() end
        Steam.userStats.uploadLeaderboardScore(info.steamLeaderboard, "KeepBest", math.floor(score * mult), nil, function(_, err2)
            if err2 then return lb:gotError() end
            print('Stats uploaded to leaderboard: completed ' .. id .. ' with ' .. score .. ' ' .. score_type)
            Steam.userStats.downloadLeaderboardEntries(info.steamLeaderboard, "Global", 1, 10000, function(results, err3)
                if err3 or results == nil or #results <= 0  then return lb:gotError() end
                for i, r in ipairs(results) do
                    results[i] = r.score / mult
                end
                local friends = {{rank = 33, name = 'robert jones', score = 12}, {rank = 1, name = 'rica the great', score = 12000}, {rank = 90, name = 'this is a very long name', score = 0}}
                lb:showResults(results, score, friends)
            end)
        end)
    end)
end

function sm.uploadCompletedStats(puzzle)
    local line_count = avg(line_count_vec, puzzle.test_count)
    local steps = avg(steps_vec, puzzle.test_count)
    line_count_vec, steps_vec = {}, {}
    -- maybe register accesses total instead of just count?
    -- ignore this for now
    --local reg_used = Util.findId('code_tab').memory:countUsed()
    print('Stats for ' .. puzzle.id .. ': Lines=' .. line_count .. ' Steps=' .. steps)
    if not USING_STEAM then return end
    if line_count <= 0 then return end
    local id = ROOM.puzzle.id
    local pop = Util.findId("popup")
    if not pop then return end
    local x, y = 590, 100
    local lb_line = Leaderboards.create(x, y, "LINES")
    local lb_cycles = Leaderboards.create(x + lb_line.w + 15, y, "CYCLES")
    pop:translate(-390,0)
    uploadScoreAndShow(id, line_count, 1, 'linecount', lb_line)
    -- not working properly. Luasteam should be improved.
    uploadScoreAndShow(id, steps, 100, 'cycles', lb_cycles)
end


return sm
