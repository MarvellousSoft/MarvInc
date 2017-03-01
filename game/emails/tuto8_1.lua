return {
    title = "Final puzzle",
    text = [[
This is it. The last things we have to teach you. The rest is on your own.

The command mov is used to move values to an address. The first argument is the value, and the second argument the address you'll move the value to.

There is also the command sub. It works analogous to the add command, but instead of adding the first two arguments and storing in the register given by the third, it will subtract.

Example where the bot will move the content of the register #7 to the register #3, and then subtract the value of register #7 by 4.
    - mov [7] 3
      sub [7] 4 7

Prove yourself worthy, employee #]] .. EMPLOYEE_NUMBER .. [[.

We are waiting you.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto8',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("mov")
        end
}
