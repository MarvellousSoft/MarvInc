--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local manager = {}

--Prints achivement progress, for debugging
function manager.print()
    print("Progress of all achievements:")
    for i,k in pairs(ACHIEVEMENT_PROGRESS) do
        print(i,k)
    end
    print("-----------------------------")
end

local scheduled_update = false

function manager.updateSteamAchievements()
    if not CAN_USE_STEAM_STATS then
        print("Can't use steam stats right now.")
        if not scheduled_update then
            scheduled_update = true
            print('Scheduling in 2s.')
            MAIN_TIMER:after(2, function()
                scheduled_update = false
                manager.updateSteamAchievements()
            end)
        end
        return
    end
    for _,k in ipairs(ACHIEVEMENT_DATABASE) do
        if ACHIEVEMENT_PROGRESS[k[1]] then
            Steam.userStats.setAchievement(k[5])
        end
    end
    Steam.userStats.storeStats()
end

function manager.load(data)
    if data then
        for i,k in pairs(ACHIEVEMENT_PROGRESS) do
            ACHIEVEMENT_PROGRESS[i] = data[i] or false
        end
        if USING_STEAM then
            manager.updateSteamAchievements()
        end
    end
end

--Completes an achievement and sends side message
function manager.complete(name)
    if not ACHIEVEMENT_PROGRESS[name] then
        ACHIEVEMENT_PROGRESS[name] = true

        if USING_STEAM and not CAN_USE_STEAM_STATS then
            -- schedule for later
            manager.updateSteamAchievements()
        elseif USING_STEAM then
            for _,k in ipairs(ACHIEVEMENT_DATABASE) do
                if k[1] == name then
                    Steam.userStats.setAchievement(k[5])
                    print(Steam.userStats.storeStats())
                    break
                end
            end
        end

        Signal.emit("new_achievement_message", name)
    end
end

--Sets all achievements to false
function manager.reset()
    for i,achievement in pairs(ACHIEVEMENT_DATABASE) do
        ACHIEVEMENT_PROGRESS[achievement[1]] = false
    end
end

--Check most achievements for completion
function manager.checkAchievements()

    --Lore progress
    if ROOM.version > "0.1" then
        manager.complete("Golden Star")
    end
    if ROOM.version > "1.0" then
        manager.complete("Senior Employee")
    end
    if ROOM.version > "2.0" then
        manager.complete("The Price of Progress")
    end
    if LoreManager.puzzle_done.ryr then
        manager.complete("EOF")
    end

    --Puzzle progress
    if LoreManager.puzzle_done.tuto1 then
        manager.complete("Baby Robot Steps")
    end
    if LoreManager.puzzle_done.paul5 then
        manager.complete("Home Decor")
    end
    if LoreManager.puzzle_done.jen_extra1 then
        manager.complete("Master of Optimization")
    end
    if LoreManager.puzzle_done.liv_extra1 then
        manager.complete("Lord Commander of the Division's Watch")
    end
    if LoreManager.puzzle_done.liv_extra2 then
        manager.complete("Sorting Doctor")
    end
    if LoreManager.puzzle_done.paul_invite then
        manager.complete("Party Boy")
    end
    if LoreManager.puzzle_done.liv3b then
        manager.complete("I Got You Bro")
    end
    if LoreManager.totalPuzzlesDone() >= TOTAL_PUZZLES_N then
        manager.complete("Best Programmer in the World")
    end

    --Dead bots
    local info_tab = Util.findId("info_tab")
    if info_tab then
        if info_tab.dead >= 1 then
            manager.complete("I, Dead Robot")
        end
        if info_tab.dead >= 10 then
            manager.complete("Spilling Oil")
        end
        if info_tab.dead >= 100 then
            manager.complete("Mechanical Genocide")
        end
    end
end

return manager
