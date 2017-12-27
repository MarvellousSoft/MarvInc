local Mail = require "classes.tabs.email"

local spam = {}

spam.require_puzzles = {'diego1'}
spam.wait = 20

function spam.run()
    Mail.new('spam2')
end

return spam
