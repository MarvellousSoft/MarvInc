return {
    title = "Working with a backpack",
    text = [[
Did you know you have an inventory?

You can pickup and drop objects, such as giant buckets, with the commands %red% pickup %end% and %red% drop %end% . They both receive the same optional argument, a direction. When provided, the %red% pickup %end% command will make the robot turn and pick any object facing that direction. If you don't provide a direction, the subject will try to pick something in the direction he is facing. In both cases he puts the object in your inventory, located below your notepad in the %blue% <code> %end% tab.

The %red% drop %end% command works the same way, but instead of picking objects, the robot will try to drop whatever he is holding in the inventory.

Example that makes the bot pickup an object from his left and placing on his right:
    - %red% pickup %green% left %end%
      %red% drop %green% right %end%

The same example as above, if the robot was facing north:
    - %red% turn %green% counter %end%
      %red% pickup %end%
      %red% turn %green% right %end%
      %red% drop %end%

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
