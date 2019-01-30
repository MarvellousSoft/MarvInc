--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local StepManager = require "classes.step_manager"

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

local multiplier = {
    linecount = 1,
    cycles = 100
}

function sm.getStatsForTest(i)
    steps_vec[i] = StepManager.ic
    line_count_vec[i] = Util.findId('code_tab'):countLines()
end

local function uploadScoreAndShow(lb, id, type, score)
    sm.findHandle(id, type, function(handle, err)
        if err then return lb:gotError() end
        Steam.userStats.uploadLeaderboardScore(handle, "KeepBest", math.floor(score * multiplier[type]), nil, function(_, err2)
            if err2 then return lb:gotError() end
            print('Stats uploaded to leaderboard: completed ' .. id .. ' with ' .. score .. ' ' .. type)
            sm.populateLeaderboard(lb, id, type, handle)
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
    pop:addLeaderboardsButton(puzzle.id, {"linecount", "cycles"})
end

function sm.findHandle(puzzle_id, type, callback)
    Steam.userStats.findOrCreateLeaderboard(puzzle_id .. '_' .. type, "Ascending", "Numeric", function (info, err)
        if err or info == nil then
            callback(nil, err)
        else
            callback(info.steamLeaderboard, err)
        end
    end)
end

-- Download scores from
function sm.populateLeaderboard(lb, puzzle_id, type, lb_handle)
    if not lb_handle then
        sm.findHandle(puzzle_id, type, function(handle, err)
            if err then
                lb:gotError()
            else
                sm.populateLeaderboard(lb, puzzle_id, type, handle)
            end
        end)
        return
    end
    local global, friends, my_score, my_best
    local function testFinish()
        if global and friends then
            lb:showResults(global, friends, my_score, my_best)
        end
    end
    Steam.userStats.downloadLeaderboardEntries(lb_handle, "Global", 1, 10000, function(results, err)
        if err or results == nil or #results <= 0 then return lb:gotError() end
        global = {}
        for i, r in ipairs(results) do
            global[i] = r.score / multiplier[type]
        end
        testFinish()
    end)
    Steam.userStats.downloadLeaderboardEntries(lb_handle, "Friends", function(results, err)
        if err or results == nil or #results <= 0 then return lb:gotError() end
        friends = {}
        local my_id = Steam.user.getSteamID()
        for i, r in ipairs(results) do
            if r.steamIDUser == my_id then
                my_score = r.score / multiplier[type]
                my_best = my_score + 1
            end
            friends[i] = {
                name = Steam.friends.getFriendPersonaName(r.steamIDUser),
                rank = r.globalRank,
                score = r.score / multiplier[type],
            }
        end
        testFinish()
    end)
end

return sm
