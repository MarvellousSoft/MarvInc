local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1'}
paul.wait = 2

function paul.run()
    Mail.new('paul2')
end

function paul.after(email)
    Mail.disableReply(email.number)
    email.can_be_deleted = true
    LoreManager.timer:after(5, function()
        Mail.new('wdinvite')
    end)
end

function paul.partied(email)
    Mail.disableReply(email.number)
    email.can_be_deleted = true
    email.referenced_email.can_be_deleted = true
    -- This is a year from now. Temp solution.
    LoreManager.timer:after(31536000, function()
        Mail.new('paul2_1')
    end)
end

function paul.open()
    LoreManager.timer:after(10, function() Mail.new('paul2_2') end)
end

return paul
