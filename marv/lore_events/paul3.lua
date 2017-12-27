local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'jen4', 'liv4', at_least = 1}
paul.wait = 15

function paul.run()
    Mail.new('radwarning')
    LoreManager.timer:after(10, function() Mail.new('paul3') end)
    LoreManager.timer:after(15, function() Mail.new('news2') end)
end

return paul
