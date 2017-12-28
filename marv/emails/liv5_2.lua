--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "[EXPLANATION] I/O Consoles",
    text = [[
Greetings, this is Richard. I'm here on behalf of Olivia to give you some insight in the {orange}I/O consoles{end}, as this is the first time you'll be working with them.

{orange}I/O consoles {end}work exactly like regular consoles, but you can both read and write {num}data {end}to it. That means, in reality, they are a place to store {red}temporary {end}data.

Data is written to the end of it, and read from the beginning, so they work in a {ds}FIFO (first in first out) {end}fashion, just like {ds}queues{end}. Remember that whenever you read some data from it, this data is {red}erased{end}.

Overall, a very simple component, and shouldn't need any further explaining.

Pleasure to meet you, carry on.

Richard Black
Programmer intern at Marvellous Inc. Software Development Department]],
    author = "Richard Black (rick.black@sdd.marv.com)",
    can_be_deleted = true
}
