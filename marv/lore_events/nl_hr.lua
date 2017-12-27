local Mail = require "classes.tabs.email"

local nl_hr = {}

-- Add puzzle 'liv7'

nl_hr.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
nl_hr.wait = 95

function nl_hr.run()
    Mail.new('hr')
end

return nl_hr
