--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local fergus = {}

-- Add email 'fergus5_fake'

fergus.require_puzzles = {'jen6', 'bm3'}
fergus.wait = 120

function fergus.run()
    LoreManager.puzzle_done.fergus5_fake_email = true
    LoreManager.check_all()
    Mail.new('fergus5_fake')
end

return fergus
