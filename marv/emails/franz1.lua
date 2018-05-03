--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local you = "Employee #" .. EMPLOYEE_NUMBER
return {
    title = "Concerning your friend.",
    text = you .. [[,

I believe we have not been properly introduced. As you probably know by now, my name is Karl Franz Friedrich Lederhosen von Linz. But people here call me {gray}Franz{end}.

I have been informed of your successes in this company. Do not think that your achievements (or actions) have gone unnoticed. As a matter of fact, we are particularly good at spotting all kinds of achievements. Good or bad.

That said, it has come to my attention that you had a rather close and personal relationship with Employee #]] .. EMPLOYEE_NUMBER + 1 .. [[, or as you may have known him: Diego Lorenzo Vega.

We have recently acquired very interesting information concerning this friend of yours. It appears he has been rather busy these past days.

It has come to our attention that Mr. Vega has been involved in very concerning subterfuge actions against this company. You see, Mr. Vega's real name is {brown}Carlos Riviera Allton{end}. He was working for a highly biased and sensationalist newspaper in an attempt to blackmail our company into giving them a large sum of money. We have also found a large quantity of illegal drugs in his office.

Do not mistake us for amateurs, ]] .. you .. [[. We do not tolerate this kind of behaviour. Loyalty is very much valued in this company, and I needn't tell you, ]] .. you .. [[, that unquestionable loyalty will get you a bright future. Do as Mr. Allton and... Well, we cannot say of what becomes of you.

Since I am a very forgiving and merciful person, I shall dismiss any previous transgressions you may have made because of Mr. Allton, and blame it on his manipulative and devious character. I have faith that you are loyal to this company, and nothing like your past friend Mr. Allton.

Having said that, indulge me for a second and kindly perform this one task for me as a proof of your loyalty and commitment to this company.

And do not forget, ]] .. you .. [[, we are shaping the future. You and everyone in this company. We are a testament to humanity's ingenuity, a model for our future sons and daughters. Do not let us all down, ]] .. you .. [[.

Karl Franz F. L. von Linz
General Executive Manager
]],
    author = "Karl Franz F. L. von Linz (kflinz@marv.com)",
    puzzle_id = 'franz1'
}
