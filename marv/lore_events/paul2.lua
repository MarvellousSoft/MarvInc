local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'liv2', 'jen2'}
paul.wait = 4

function paul.run()
    Mail.new('paul2_1')
    LoreManager.timer:after(10, function() Mail.new('paul2_2') end)
end

function paul.after()
    Mail.new('paul2_3')
end

return paul
