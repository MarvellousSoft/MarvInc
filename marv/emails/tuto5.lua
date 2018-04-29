--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Working with a backpack",
    text = [[
Did you know you have an inventory?

You can pickup and drop objects, such as giant buckets, with the commands {inst}pickup {end}and {inst}drop{end}. They both receive the same optional argument, a {dir}direction{end}. When provided, the {inst}pickup {end}command will make the robot turn and pick any object facing that direction. If you don't provide a {dir}direction{end}, the subject will try to pick something in the direction he is facing. In both cases he puts the object in your inventory, located below your notepad in the {tab}<code> {end}tab.

The {inst}drop {end}command works the same way, but instead of picking objects, the robot will try to drop whatever he is holding in the inventory.

Example that makes the bot pickup an object from his left and placing on his right:
      {inst}pickup {dir}left{end}
      {inst}drop {dir}right{end}

The same example as above, if the robot was facing north:
      {inst}turn {dir}counter{end}
      {inst}pickup{end}
      {inst}turn {dir}right{end}
      {inst}drop{end}

You only have one inventory slot, so plan your actions properly.

Happy adventuring, and carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto5',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("pickup1")
            Util.findId('manual_tab'):addCommand("drop1")
        end
}
