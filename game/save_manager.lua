local LoreManager = require "classes.lore-manager"
binser = require "binser"

local sm = {}
local f = love.filesystem -- used a lot
sm.user_data = {}

function sm.login(user)
    if sm.current_user then sm.logout() end
    sm.current_user = user
    local data = sm.user_data[user]
    if data then
        LoreManager.puzzle_done = data.puzzle_done
        LoreManager.check_all()
    end

end

function sm.logout()
    assert(sm.current_user)
    sm.save()
    sm.current_user = nil
end

function sm.load()
    if not f.exists("README") then
        f.write("README", [[
This is Marvellous Inc's save directory.

Feel free to mess up the files here, but if the game crashes it is not our responsability :)]])
    end
    if not f.exists("saves") then
        f.createDirectory("saves")
    end
    for _, user in pairs(f.getDirectoryItems("saves")) do
        sm.user_data[user] = binser.deserializeN(f.read('saves/' .. user .. '/save_file'), 1)
    end
end

function sm.base_user_save(user)
    if not f.exists('saves/' .. user) then
        f.createDirectory('saves/'.. user)
    end
end

function sm.save()
    local user = sm.current_user
    if not user then return end
    sm.base_user_save(user)
    local data = {}
    data.puzzle_done = LoreManager.puzzle_done
    -- ...

    f.write('saves/' .. user .. '/save_file', binser.serialize(data))
end

function sm.load_code(puzzle)
    local filename = 'saves/' .. sm.current_user .. '/' .. puzzle .. '.code'
    if f.exists(filename) then return f.read(filename) end
end

function sm.save_code(puzzle, str)
    sm.base_user_save(sm.current_user)
    local filename = 'saves/' .. sm.current_user .. '/' .. puzzle .. '.code'
    f.write(filename, str)
end

return sm
