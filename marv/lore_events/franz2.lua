local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'jen6', 'bm3'}
franz.wait = 15

function franz.run()
    Mail.new('franz2')

    LoreManager.timer:after(15, function() Mail.new('news3') end)
end

return franz
