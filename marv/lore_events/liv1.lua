--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv1'

liv.require_puzzles = {'jen1', 'paul1', 'fergus1'}
liv.wait = 8

function liv.run()
    Mail.new('liv1_1')
end

return liv
