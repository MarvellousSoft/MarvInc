local Mail = require "classes.tabs.email"

local nl_hr = {}

-- Add puzzle 'liv7'

nl_hr.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
nl_hr.wait = 5

function nl_hr.run()
    Mail.new('news3')
    LoreManager.timer:after(90, function() Mail.new('hr') end)
end

return nl_hr
