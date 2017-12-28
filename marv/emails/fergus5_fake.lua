--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local orig = require('emails.fergus5')

love.math.setRandomSeed(999)
local function crypto(s)
    local cs = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM[]\\|;:,<.>/?\"'"
    return string.gsub(s, "%S", function()
        local k = love.math.random(1, #cs)
        return cs:sub(k, k)
    end)
end

return {
    title = crypto(orig.title),
    text = crypto(orig.text),
    author = "Jorge Davidson (jorge.davidson.74837897@gmail.com)"
}
