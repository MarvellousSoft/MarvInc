local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1'}
paul.wait = 4

function paul.run()
    Mail.new('paul2')
end

function paul.after(email)
    Mail.disableReply(email.number)
    email.can_be_deleted = true
    email.referenced_email.can_be_deleted = true
    LoreManager.timer:after(5, function()
        Mail.new('wdinvite')
    end)
end

return paul
