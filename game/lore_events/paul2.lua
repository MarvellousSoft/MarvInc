local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul1'}
paul.wait = 2
paul.last = nil

function paul.run()
    local email = Mail.new('paul2')
    paul.last = email
end

function paul.after()
    Mail.disableReply(paul.last.number)
    paul.last.can_be_deleted = true
    LoreManager.timer:after(5, function()
        local email = Mail.new('wdinvite')
        paul.last = email
    end)
end

function paul.partied()
    Mail.disableReply(paul.last.number)
    paul.last.can_be_deleted = true
    -- This is a year from now. Temp solution.
    LoreManager.timer:after(31536000, function()
        local email = Mail.new('paul2_1')
    end)
end

function paul.open()
    LoreManager.timer:after(10, function() Mail.new('paul2_2') end)
end

return paul
