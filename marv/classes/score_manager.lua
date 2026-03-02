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
local _stats_uploaded
local _number_of_stats = 2

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

local last_score = {
    linecount = nil,
    cycles = nil
}

function sm.getStatsForTest(i)
    steps_vec[i] = StepManager.ic
    line_count_vec[i] = Util.findId('code_tab'):countLines()
end

local function uploadScore(id, type, score)
    last_score[type] = math.floor(score * multiplier[type]) / multiplier[type]
    sm.findHandle(id, type, function(handle, err)
        if err then
           print("Could not find leaderboard handle")
           local pop = Util.findId("popup")
           if pop then
             pop:showInfo("Couldn't upload stats.")
             pop:errorLeaderboardsButton()
           end
           return
        end
        Steam.UserStats.UploadLeaderboardScore(handle, Steam.k_ELeaderboardUploadScoreMethodKeepBest, math.floor(score * multiplier[type]), {}, 0, function(data, err2)
            if err2 or data.m_bSuccess == 0 then
              print("Could not upload score")
              local pop = Util.findId("popup")
              if pop then
                pop:showInfo("Couldn't upload stats.")
                pop:errorLeaderboardsButton()
              end
              return
            end
            --Stats uploaded sucessfully
            _stats_uploaded = _stats_uploaded + 1
            if _stats_uploaded >= _number_of_stats then
              local pop = Util.findId("popup")
              if pop then
                pop:showInfo("Leaderboards ready!")
                pop:enableLeaderboardsButton()
              end
            end
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
    
    if not USING_STEAM then return end
    if line_count <= 0 then return end
    local id = ROOM.puzzle.id
    local pop = Util.findId("popup")
    if not pop then return end
    pop:showInfo("Uploading stats...")
    _stats_uploaded = 0
    uploadScore(id, 'linecount', line_count)
    uploadScore(id, 'cycles', steps)
    pop:addLeaderboardsButton(puzzle.id, {"linecount", "cycles"})
end

function sm.findHandle(puzzle_id, type, callback)
    Steam.UserStats.FindOrCreateLeaderboard(puzzle_id .. '_' .. type, Steam.k_ELeaderboardSortMethodAscending, Steam.k_ELeaderboardDisplayTypeNumeric, function (info, err)
        print('FindOrCreateLeaderboard info, err:', info, err)
        if err or info == nil then
            callback(nil, err)
        else
            callback(info.m_hSteamLeaderboard, err)
        end
    end)
end

-- Download scores from
function sm.populateLeaderboard(lb, puzzle_id, type, use_player_score, lb_handle)
    if not lb_handle then
        sm.findHandle(puzzle_id, type, function(handle, err)
            if err then
                lb:gotError()
            else
                sm.populateLeaderboard(lb, puzzle_id, type, use_player_score, handle)
            end
        end)
        return
    end
    local global, friends, my_score, my_best
    if use_player_score then
        my_score = last_score[type]
    end
    local function testFinish()
        if global and friends then
            lb:showResults(global, friends, my_score, my_best)
        end
    end
    print('Requesting leaderboard entries...', lb_handle)
    Steam.UserStats.DownloadLeaderboardEntries(lb_handle, Steam.k_ELeaderboardDataRequestGlobal, 1, 10000, function(data, err)
        print('DownloadLeaderboardEntries global callback', data, err)
        if err or data.m_cEntryCount <= 0 then return lb:gotError() end
        global = {}
        for i = 0, data.m_cEntryCount - 1 do
            local ok, entry = Steam.UserStats.GetDownloadedLeaderboardEntry(data.m_hSteamLeaderboardEntries, i, 0)
            if ok then
                global[i + 1] = entry.m_nScore / multiplier[type]
            end
        end
        testFinish()
    end)
    print("My id is", Steam.User.GetSteamID())
    Steam.UserStats.DownloadLeaderboardEntries(lb_handle, Steam.k_ELeaderboardDataRequestFriends, 0, 0, function(data, err)
        print('DownloadLeaderboardEntries friends callback', data, err)
        if err or data.m_cEntryCount <= 0 then return lb:gotError() end
        print('Got', data.m_cEntryCount, 'friend entries')
        friends = {}
        print('Getting my id ', Steam)
        print(Steam.User, Steam.User.GetSteamID)
        local my_id = Steam.User.GetSteamID()
        print("Got it")
        print('My SteamID:', my_id)
        for i = 0, data.m_cEntryCount - 1 do
            print('Getting entry', i, 'of', data.m_cEntryCount)
            local ok, entry = Steam.UserStats.GetDownloadedLeaderboardEntry(data.m_hSteamLeaderboardEntries, i, 0)
            if ok then
                if entry.m_steamIDUser == my_id then
                    my_best = entry.m_nScore / multiplier[type]
                end
                friends[i + 1] = {
                    name = Steam.Friends.GetFriendPersonaName(entry.m_steamIDUser),
                    rank = entry.m_nGlobalRank,
                    score = entry.m_nScore / multiplier[type],
                }
            end
        end
        testFinish()
    end)
end

return sm
