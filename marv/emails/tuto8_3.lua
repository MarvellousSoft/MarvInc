--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Number limits",
    text = [[
As you {green}certainly{end} know by now, {addr}register {num}contents {end}can hold {num}values {end}from {purple}-999{end} to {purple}999{end}. This task asks for the square of a number up to 30, that is convenient, since that value is less than {purple}999{end}. {blue}But what happens when we perform an operation that takes us out of these bounds?{end}

Even a simple operation like { {inst}add {num}500 500 {addr}0{end} } brings this doubt. Will the value in {addr}register #0 {end}be {purple}999{end}? Or will it throw a Runtime Error? Actually, none of those. The value will be {purple}-999{end}. Why is that? You could think that the numbers are cyclical, they go from {purple}-999{end} to {purple}999{end}, and the number after {purple}999{end} is {purple}-999{end}.
So we have:

 {blue}500{end} + {blue}500{end} = {purple}-999{end}
 {blue}-600{end} - {blue}500{end} = {purple}899{end} and
 {blue}50{end} * {blue}50{end} = {purple}501{end}.

A good robot specialist should know these things. You may one day {red}need it{end}.

Keep your eyes open, and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
