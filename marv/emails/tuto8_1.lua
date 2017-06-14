return {
    title = "Final puzzle",
    text = [[
This is it. The last things we have to teach you. The rest is on your own.

The command %red% mov %end% is used to move %green% values %end% to an %cyan% address %end% . The first argument is the %green% value %end% , and the second argument the %cyan% address %end% you'll move the %green% value %end% to.

There is also the command %red% sub %end% . It works analogous to the %red% add %end% command, but instead of adding the first %green% two arguments %end% and storing in the %cyan% register %end% given by the %cyan% third %end% , it will subtract.

Example where the bot will move the %green% content %end% of the %cyan% register #7 %end% to the %cyan% register #3 %end% , and then subtract the %green% value %end% of %cyan% register #7 %end% by %green% 4 %end% .
    - %red% mov %green% [7] %cyan% 3 %end%
      %red% sub %green% [7] 4 %cyan% 7 %end%

Prove yourself worthy, employee #]] .. EMPLOYEE_NUMBER .. [[.

We are waiting you.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto8',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("sub1", "sub")
            Util.findId('manual_tab'):changeCommand("add1", "add")
            Util.findId('manual_tab'):changeCommand("mov1", "mov")
            Util.findId('manual_tab'):changeCommand("jmp1", "jmp2")
        end
}
