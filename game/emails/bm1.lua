local bm = require 'lore_events.bm1'

return {
    title = "Remember us?",
    text = [[
Hey it's Miles Evans and Bill Davies, the two sharp looking Math PhDs you met at Paul's. We heard wonders from both P and L about your achievements, and we just might need someone of your talents.

As you may remember from our conversation last night, we are both number theorists with emphasis on cryptography. This means working with large primes or at least pseudoprimes. Which in turn means working with large numbers, and as everyone knows, mathematicians hate calculating by hand. That's where you come in. We are mathematicians, so we do the theory, and you do the number crunching. How about that? We are sending you a simple problem. If you decide to help us, complete this puzzle and we can talk.

(I'm cc-ing Bill so you can get in touch with either of us)

Miles Evans
PhD in Applied Mathematics
Researcher at Marvellous Inc's Cryptography Department
]],
    author = "Miles Evans [cc: Bill Evans]",
    reply_func = bm.after
}
