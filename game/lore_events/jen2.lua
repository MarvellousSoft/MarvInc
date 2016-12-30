local Mail = require "classes.tabs.email"

local jen = {}

-- Add puzzle 'jen2'

jen.require_puzzles = {'jen1'}
jen.wait = 15

function jen.run()
    Mail.new('jen2')
end

return jen
