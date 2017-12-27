--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local Mail = require "classes.tabs.email"

local fergus = {}

-- Add puzzle 'fergus2'

fergus.require_puzzles = {'fergus1'}
fergus.wait = 30

function fergus.run()
    Mail.new('fergus2')
end

return fergus
