local Mail = require "classes.tabs.email"

local spam = {}

-- Add puzzle 'spam'

spam.require_puzzles = {'jen7', 'paul5', 'fergus5_fake_email'}
spam.wait = 5

function spam.run()
    Mail.new('spam3')
end

return spam
