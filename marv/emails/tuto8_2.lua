--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Advanced ways to handle values",
    text = [=[
Since you've reached this far, you have proven yourself almost qualified to work on our most professional jobs, here at Marvellous Inc. Here are some advanced ways to manipulate {num}values {end}and {addr}addresses{end}.

You already know that {num}[8] {end}represents the {num}value {end}inside the {addr}register #8{end}, but did you know you can also write {num}[[8]]{end}? This returns the {num}content {end}inside the {addr}register {end}whose number is the {num}content {end}inside the {addr}register 8{end}! This may sound confusing, but here is an example so you can better understand.

We have the {addr}register #1 {end}with the {num}content 50{end}, and the {addr}register #5 {end}with the {num}content 1{end}. Now look at the following code:
      {inst}walk {num}[[5]] {end}

This will make the robot walk {num}50 {end}spaces forward, since {num}[5] {end}equals to {num}1{end}, and {num}[1] {end}equals to {num}50{end}.

You can keep adding [ ]'s as many times as you like to a {num}value{end}, such as {num}[[[[5]]]]{end}, referencing deeper and deeper {addr}registers{end}. Just make sure you won't try to access a {addr}register {end}with an invalid {num}number{end}.

As an almost professional in this area, you should learn well this technique, since it will be crucial for more challenging jobs.

Another possibility is using {addr}registers {end}to store numeric {lab}labels{end}. That means { {inst}jmp {num}[5]{end} } will jump to the {lab}label{end} that is stored in {addr}register #5{end}. If there is no such {lab}label{end} with that {num}number{end}, you will get an error. You probably won't need this soon, but it is always better to know.

In the following code, if the {addr}register #7{end} has the {num}content 12{end}, then the robot will turn clockwise forever, if it has {num}content 13{end}, it will walk down. Otherwise, it will throw an error.
      {lab}12: {inst}turn {dir}clock{end}
      {inst}jmp {lab}[7]{end}
      {lab}13: {inst}walk {dir}down{end}

Never stop learning, and carry on.
]=],
    author = "Automated Introduction System",
    can_be_deleted = true
}
