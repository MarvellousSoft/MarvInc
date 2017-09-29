local Mail = require "classes.tabs.email"

local this = {}

this.require_puzzles = {'liv7a', 'liv7b'}
this.wait = 10

function this.run()
    Mail.new('hr')
    LoreManager.timer:after(10, function()
        Mail.new('nl')
    end)
    LoreManager.timer:after(15, function()
        Mail.new('franz1_3')
    end)
    LoreManager.timer:after(25, function()
        Mail.new('jen6')
    end)
    LoreManager.timer:after(17, function()
        Mail.new('bm3')
    end)
    LoreManager.timer:after(19, function()
        Mail.new('bm3_1')
    end)
end

return this
