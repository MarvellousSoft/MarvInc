local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1'}
paul.wait = 4

function paul.run()
    Mail.new('paul2')
    LoreManager.timer:after(10, function()
        Mail.new('wdinvite')
    end)
end

function paul.after(email)
    Mail.disableReply(email.number)
    email.can_be_deleted = true
end

return paul
