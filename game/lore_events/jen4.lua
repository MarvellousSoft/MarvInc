local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'fergus4'} --TODO Change this to only appear after act1 ending.
jen.wait = 20

local after_intro_email

function jen.run()
    Mail.new('jen4')
end

-- called after jen email is read
function jen.after_email()

    LoreManager.timer:after(15, function() Mail.new('binary') end) --Send bill and miles binary explanation

end


return jen
