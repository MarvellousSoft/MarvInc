--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local p = require 'lore_events.paul2'
local prev = require 'lore_events.paul1_2'

return {
    title = "Notification: Party at mine @ April 20",
    text = [[
The day that everyone has been waiting for is upon us. In this day we celebrate what the Universe has granted us of most precious. This little gift of Mother Nature is our muse, our inspiration. It's what we turn to on our toughest days and darkest nights. It's what fuels our dreams and minds. So let's give it a proper party, the way it's supposed to be partied. I invite you to...

~~ Weed Day | April 20th ~~
At my place. Be there at any time, leave whenever.

Contact and address information is attached.

This is an automatic invitation sent by MarvCalendar.

{red}<Reply to go to the party>{end}
]],
    author = "Automated Marvellous Calendar (calendar-notification@marv.com)",
    reply_func = prev.after
}
