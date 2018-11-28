--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Never Gonna Give Binaries Up",
    text = [[
  Hey there {purple}wannabe hacker{end}, you know what's {orange}major rad{end}? No, not The Goonies you dweeb, {yellow}binary numbers{end}! {pink}:-){end}

  This eletronic mail (or as we in the tech department like to call, {brown}e-mail{end} {pink};-D{end}) will teach all about those before you can call Ghostbusters.

  First things first, how do we write {pink}three hundred and forty two{end} in our usual numerical system? Well, that's major easy, it's {blue}342{end}, which means

  {blue}3{end}x{purple}100{end} + {blue}4{end}x{purple}10{end} + {blue}2{end}x{purple}1{end}

  which is totally the same as

  {blue}3{end}x{green}10{end}^{orange}2{end} + {blue}4{end}x{green}10{end}^{orange}1{end} + {blue}2{end}x{green}10{end}^{orange}0{end}

  Actually any number we write will have the same formula. If our number has {orange}5{end} digits {blue}d4{end}, {blue}d3{end}, {blue}d2{end}, {blue}d1{end}, {blue}d0{end}, we can write it as:

  {blue}d4{end}x{green}10{end}^{orange}4{end} + {blue}d3{end}x{green}10{end}^{orange}3{end} + {blue}d2{end}x{green}10{end}^{orange}2{end} + {blue}d1{end}x{green}10{end}^{orange}1{end} + {blue}d0{end}x{green}10{end}^{orange}0{end}

  And a number with {orange}n{end} digits would have the formula:

  {blue}d(n){end}x{green}10{end}^{orange}n{end} + {blue}d(n-1){end}x{green}10{end}^{orange}(n-1){end} + {blue}d(n-2{end})x{green}10{end}^{orange}(n-2){end} + {gray}.....{end} + d1x{green}10{end}^{orange}1{end} + d0x{green}10{end}^{orange}0{end},

  Where {blue}d(n){end}, {blue}d(n-1){end}, {gray}...{end}, {blue}d1{end} and {blue}d0{end} can be any number from {blue}0-9{end}.

  We call our numerical system the {red}Decimal Numerical System{end}! You don't have to be no Emmet Brown from Back to the Future to see that, ain't I right doc? {pink};-P{end}

  Ok, let's take it to the max, I can tell you are getting stoked about this. What if, instead of using all our {blue}10{end} digits, we just used {blue}0{end} and {blue}1{end}. Could we write any number just those? Yes! We just have to use a {red}Binary Numerical System{end}! Cowabunga!

  So, for instance, the number {pink}342{end} in binary would be {blue}101010110{end}, which means

  {blue}1{end}x{green}2{end}^{orange}8{end} + {blue}0{end}x{green}2{end}^{orange}7{end} + {blue}1{end}x{green}2{end}^{orange}6{end} + {blue}0{end}x{green}2{end}^{orange}5{end} +     {blue}1{end}x{green}2{end}^{orange}4{end} + {blue}0{end}x{green}2{end}^{orange}3{end} + {blue}1{end}x{green}2{end}^{orange}2{end} + {blue}1{end}x{green}2{end}^{orange}1{end} + {blue}0{end}x{green}2{end}^{orange}0{end}

  that is, like, the same as

  {blue}1{end}x{purple}256{end} + {blue}0{end}x{purple}128{end} + {blue}1{end}x{purple}64{end} + {blue}0{end}x{purple}32{end} + {blue}1{end}x{purple}16{end} + {blue}0{end}x{purple}8{end} + {blue}1{end}x{purple}4{end} + {blue}1{end}x{purple}2{end} + {blue}0{end}x{purple}1{end}

  The principles are the same, but instead of multiplying the digits by a power of {blue}10{end}, we multiply them by a power of {blue}2{end}!

  Wanna learn about other numerical systems like {purple}hexadecimal{end}? Well barf me out of this one, 'cause I pity the fool who has time for that, and I'm late for a Star Wars trilogy marathon (I bet episode 1 is going to be {pink}tubular{end}!)

  Remember, {red}SAY NO TO DRUGS{end} and have a cow man {pink}B-){end}
    ]],
    author = "Automatic Eletronic Mail (aem@marv.com)",
    can_be_deleted = true
}
