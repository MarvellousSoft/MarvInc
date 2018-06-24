--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1'}
paul.wait = 4

function paul.run()
    Mail.new('paul2')
    LoreManager.timer:after(10, function()
        Mail.new('wdinvite')
    end)
end

function paul.after(email)
    Mail.disableReply(email.number)
    email.can_be_deleted = true
    local lore = require "classes.lore_manager"
    lore.puzzle_done.paul_invite = true
    AchManager.checkAchievements()
    lore.check_all()
end

return paul
