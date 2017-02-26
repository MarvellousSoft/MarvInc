local LoreManager = require "classes.lore_manager"
local Mail = require "classes.tabs.email"

local first = {}

first.require_puzzles = {}
first.wait = 1

local after_intro_email

function first.run()
    Mail.new('tuto1_1')
end

-- called after first email is read
function first.after_intro_email()
    LoreManager.timer:after(1, function() Mail.new('tuto1_2') end)

    LoreManager.timer:after(30, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_3') end
    end)

    LoreManager.timer:after(60, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_4') end
    end)

    LoreManager.timer:after(120, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_5') end
    end)
end



return first
