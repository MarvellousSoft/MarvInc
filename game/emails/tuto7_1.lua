return {
    title = "Comparing and jumping",
text = [[
We are almost finished with the introdutory puzzles.

We now introduce the conditional jumps. There are several of them, and shortly you'll receive an email explaining what condition each one represent.

They all receive three arguments: two values and a label. If the condition of the jump is satisfied, it will jump to the label, just like a normal jmp. If the condition returns false, it will just go to the next instruction as if nothing happened.

For instance, the jgt command is the Greater Than Jump. So if the first value received is greater than the second one, it will jump to the label given as a third argument.

Example where the bot will increase the value of the register #1 until its equal or greater than the value of the register #2. Only then it will walk 1 tile.
    - omar: add [1] 1 1
      jgt [2] [1] omar
      walk 1

Lastly you can use the read command to read input from a console. You provide a first argument with the address of the register to store the input read, and a second optional direction, analogous to the write.

Notice that read is different than write because it receives an addres and not a value. That means reading from console to register #0 uses the command read 0, and writing to the console from the same register uses the command write [0]. Be careful.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto7',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("read1", "read")
            Util.findId('manual_tab'):changeCommand("write1", "write")
            Util.findId('manual_tab'):addCommand("cond_jmps")
        end
}
