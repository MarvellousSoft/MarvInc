local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'act1'}
jen.wait = 20

function jen.run()
    Mail.new('jen4')
end

-- called after jen email is read
function jen.after_email()

    LoreManager.timer:after(15, function() Mail.new('binary') end) -- Send explanation

end


return jen
