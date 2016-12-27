local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local square = {}

-- Adds the puzzle "Squaring"

square.require_puzzles = {"array_sep"}
square.wait = 4

function square.run()
    LoreManager.email.square = Mail.new("Final puzzle",
[[
This is it. The last things we have to teach you. The rest is on your own.

The command mov is used to move values to an address. The first argument is the address, and the second argument the value you'll move to that address.

There is also the command sub. It works analogous to the add command, but instead of adding the second argument to the address provided in the first argument, it will subtract.

Example where the bot will move the content of the register #7 to the register #3, and then subtract it by 4
    - mov 3 [7]
      sub 3 4

Prove yourself worthy, employee #]] .. EMPLOYER_NUMBER .. [[.

We are waiting you.

Carry on.
]], "Automated Introduction System", false, 'square',
    function()
        Info.addCommand("mov <address> <value>")
        Info.addCommand("sub <address> <value>")
    end)

    LoreManager.timer.after(5, function()
    Mail.new("New ways to handle values",
[=[
Since you've reached this far, you have proven yourself almost qualified to work on our most professional jobs, here at Marvellous Inc. Here are some advanced ways to manipulate values and addresses.

You already know that [8] represents the value inside the register #8, but did you know you can also write [[8]]? This returns the content inside the register whose number is the content inside the register 8! This may sound confusing, but here is an example so you can better understand.

We have the register #1 with the content 50, and the register #5 with the content 1. Now look at the following code:
    - walk [[5]]

This will make the robot walk 50 spaces forward, since [5] equals to 1, and [1] equals to 50.

You can keep adding []'s as many times as you like to a value, such as [[[[5]]]], referencing deeper and deeper registers. Just make sure you won't try to access a register with an invalid number.

As an almost professional in this area, you should learn well this technique, since it will be crucial for more challenging jobs.

Never stop learning, and carry on.
]=], "Automated Introduction System", true)
    end)
end

return square
