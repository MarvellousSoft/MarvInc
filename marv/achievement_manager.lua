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
return manager
