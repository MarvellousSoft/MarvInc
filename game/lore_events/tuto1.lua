local LoreManager = require "classes.lore_manager"
local Mail = require "classes.tabs.email"

local first = {}

first.require_puzzles = {}
first.wait = 1 --TODO change to 5 on release

local after_intro_email

function first.run()
    Mail.new('tuto1_1')
end

-- called after first email is opened
function first.after_intro_email()
    LoreManager.timer:after(20, function() Mail.new('tuto1_2') end)

    LoreManager.timer:after(90, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_3') end
    end)

    LoreManager.timer:after(180, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_4') end
    end)

    LoreManager.timer:after(300, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_5') end
    end)
end



return first
