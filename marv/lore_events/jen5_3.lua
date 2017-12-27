--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'act2'}
jen.wait = 180

function jen.run()
    Mail.new('jen5_3')
end

return jen
