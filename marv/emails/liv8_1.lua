--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "BIG project",
    text = [[
Hey! Exciting new {red}project {end}coming up, and I put {red}you {end}on the {red}center {end}of it. We're starting the first phase of our {purple}Project Brainfuck{end}. I'm sure you've heard what the FBI is trying to do to us, but we're smarter than that. We're gonna fight back, and we're gonna win. That's the essence of {purple}Project Brainfuck{end}.

To open up new possibilites in the world of hacking, we first need to implement an advanced programming language called {blue}brainfuck{end}.

Here's what's gonna happen: you're gonna write the {blue}interpreter{end}, using L++, we here at software are gonna start prepping up the big guns to be able to use this language to infiltrate whoever is trying to get us.

If you still don't know this language, let me give you the basics: you have a big circular array (after the last element is the first), and there is always a {addr}data pointer {end}pointing to some position of that array. It starts on position 0, and all {num}values {end}are initialized to 0. Commands usually change this pointer or the contents of the pointed array position. {red}Pretty powerful, huh?{end}

For now, just implement the simple instructions:
  {inst}>{end}: increment (increase by one) the {addr}data pointer{end}
  {inst}<{end}: decrement (decrease by one) the {addr}data pointer{end}
  {inst}+{end}: increment the {num}value {end}pointed by the {addr}data pointer{end}
  {inst}-{end}: decrement the {num}value {end}pointed by the {addr}data pointer{end}
  {inst}.{end}: write the {num}value {end}pointed by the {addr}data pointer {end}to the {blue}blue console{end}
  {inst},{end}: read one {num}value {end}from the {green}green console {end}and write it to the position pointed by the {addr}data pointer{end}

The code is on the {gray}white console{end}. Let's use the size of the array as 20 for our project.

{blue}<+-+>{end}, and carry on.

-- Liv

ps. HAHAHAH You must be thinking I'm retarded. We both know {blue}brainfuck{end} is useless and this is a shit project, but the higher ups think this is {gray}Mr. Robot{end} and we can just hack the FBI. So I'm posing this {purple}Project Brainfuck{end} as a counter-hack project AHAHHAHAHAHAa. They're so fucking stupid they won't even notice.

ps2. {gray}Mr. Robot{end} is still a pretty great show. Do watch.]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv8'
}
