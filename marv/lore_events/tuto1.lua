--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local LoreManager = require "classes.lore_manager"
local Mail = require "classes.tabs.email"

local first = {}

first.require_puzzles = {}
first.wait = 3

local after_intro_email

function first.run()
    Mail.new('tuto1_1')
end

--Called after first email is opened
function first.after_intro_email()

    LoreManager.timer:after(10, function() Mail.new('tuto1_2') end)

end

--Called after reading the puzzle text
function first.after_puzzle_email()

    LoreManager.timer:after(120, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_3') end
    end)

end

--Called after reading the first help email text
function first.after_help1_email()

    LoreManager.timer:after(120, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_4') end
    end)

end

--Called after reading the second help email text
function first.after_help2_email()

    LoreManager.timer:after(120, function()
        if not LoreManager.puzzle_done.tuto1 then Mail.new('tuto1_5') end
    end)

end


return first
