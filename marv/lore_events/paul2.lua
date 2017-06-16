local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'liv2', 'jen2'}
paul.wait = 4

function paul.run()
    LoreManager.timer:after(10, function() Mail.new('paul2_1') end)
    LoreManager.timer:after(20, function() Mail.new('paul2_2') end)
end

return paul
