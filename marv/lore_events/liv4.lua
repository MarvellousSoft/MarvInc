--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv4'

liv.require_puzzles = {'act1'}
liv.wait = 50

function liv.run()
    Mail.new('liv4')
end

return liv
