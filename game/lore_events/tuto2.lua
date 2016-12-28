local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local walkx = {}

-- Adds the puzzle that teaches using walk X

walkx.require_puzzles = {"first"}
walkx.wait = 4

function walkx.run()
    Mail.new('tuto2_1')

    LoreManager.timer:after(5, function() Mail.new('tuto2_2') end)
end

return walkx
