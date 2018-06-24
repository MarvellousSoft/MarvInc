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

function manager.load(data)
    if data then
        for i,k in pairs(ACHIEVEMENT_PROGRESS) do
            ACHIEVEMENT_PROGRESS[i] = data[i] or false
        end
    end
end

--Completes an achievement and sends side message
function manager.complete(name)
    if not ACHIEVEMENT_PROGRESS[name] then
        ACHIEVEMENT_PROGRESS[name] = true
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
        manager.complete("Complete")
    end
    --Puzzle progress
    if LoreManager.puzzle_done.tuto1 then
        manager.complete("first")
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
    if LoreManager.totalPuzzlesDone() >= TOTAL_PUZZLES_N then
        manager.complete("Best Programmer in the World")
    end

    --Dead bots
    local info_tab = Util.findId("info_tab")
    if info_tab then
        if info_tab.dead >= 1 then
            manager.complete("1")
        end
        if info_tab.dead >= 10 then
            manager.complete("10")
        end
        if info_tab.dead >= 100 then
            manager.complete("100")
        end
    end
end

return manager
