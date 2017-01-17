local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1', 'liv1'}
paul.wait = 5

function paul.run()
    Mail.new('paul2')
end

function paul.after()
    LoreManager.timer:after(5, function() Mail.new('wdinvite') end)
end

function paul.partied()
    -- This is a year from now. Temp solution.
    LoreManager.timer:after(31536000, function() Mail.new('paul2_1') end)
end

function paul.open()
    LoreManager.timer:after(10, function() Mail.new('paul2_2') end)
end

return paul
