local Mail = require "classes.tabs.email"

local liv = {}

liv.require_puzzles = {'liv_extra1'}
liv.wait = 2

function liv.run()
    Mail.new('liv_extra1_done')
end

return liv
