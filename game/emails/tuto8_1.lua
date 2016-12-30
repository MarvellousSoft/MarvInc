local Info = require 'classes.tabs.info'

return {
    title = "Final puzzle",
    text = [[
This is it. The last things we have to teach you. The rest is on your own.

The command mov is used to move values to an address. The first argument is the address, and the second argument the value you'll move to that address.

There is also the command sub. It works analogous to the add command, but instead of adding the second argument to the address provided in the first argument, it will subtract.

Example where the bot will move the content of the register #7 to the register #3, and then subtract it by 4
    - mov 3 [7]
      sub 3 4

Prove yourself worthy, employee #]] .. EMPLOYER_NUMBER .. [[.

We are waiting you.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto8',
    open_func =
        function()
            Info.addCommand("mov <address> <value>")
            Info.addCommand("sub <address> <value>")
        end
}
