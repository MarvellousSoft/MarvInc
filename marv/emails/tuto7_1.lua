return {
    title = "Comparing and jumping",
text = [[
We are almost finished with the introdutory puzzles.

We now introduce the %red% conditional jumps %end% . There are several of them, and shortly you'll receive an email explaining what condition each one represent.

They all receive three arguments: two %green% values %end% and a %purple% label %end% . If the condition of the jump is satisfied, it will jump to the %purple% label %end% , just like a normal %red% jmp %end% . If the condition is false, it will just go to the next instruction as if nothing happened.

For instance, the %red% jgt %end% command is the %red% Greater Than Jump %end% . So if the first %green% value %end% received is greater than the %green% second one %end% , it will jump to the %purple% label %end% given as a third argument.

Example where the bot will increase the %green% value %end% of the %cyan% register #1 %end% until its equal or greater than the %green% value %end% of the %cyan% register #2 %end% . Only then it will walk %green% 7 %end% tiles.
    - %purple% omar: %red% add %green% [1] 1 %cyan% 1 %end%
      %red% jgt %green% [2] [1] %purple% omar %end%
      %red% walk %green% 7 %end%

Lastly you can use the %red% read %end% command to read input from a %orange% console %end% . You provide a first argument with the %cyan% address %end% of the %cyan% register %end% to store the input read, and a second optional %pink% direction %end% , analogous to the %red% write %end% command.

Notice that %red% read %end% is different than %red% write %end% because it receives an %cyan% address %end% and not a %green% value %end% . That means reading from %orange% console %end% to %cyan% register #0 %end% uses the command [ %red% read %cyan% 0 %end% ] , and writing to the %orange% console %end% from the same %cyan% register %end% uses the command [ %red% write %green% [0] %end% ] . Be careful.

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
