local Mail = require "classes.tabs.email"

local spam = {}

spam.require_puzzles = {'liv2'}
spam.wait = 30

function spam.run()
    Mail.new('spam1')
end

return spam
