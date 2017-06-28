return {
    title = "BIG project",
    text = [[
Hey! Exciting new %red% project %end% coming up, and I put %red% you %end% on the %red% center %end% of it. We up here are gonna start 'researching' %blue% brainfuck %end% . If you're not aware, %blue% brainfuck %end% is a simple esoteric programming language.

Here's what's gonna happen: you're gonna write the %blue% interpreter %end% , using L++, we here at software are gonna start testing what we can do with the language.

If you still don't know this language, let me give you the basics: you have a big circular array (after the last element is the first), and there is always a %addr% data pointer %end% pointing to some position of that array. It starts on position 0, and all %num% values %end% are initialized to 0. Commands usually change this pointer or the contents of the pointed array position. Pretty easy, huh?

For now, just implement the simple instructions:
  %inst% > %end% : increment (increase by one) the %addr% data pointer %end%
  %inst% < %end% : decrement (decrease by one) the %addr% data pointer %end%
  %inst% + %end% : increment the %num% value %end% pointed by the %addr% data pointer %end%
  %inst% - %end% : decrement the %num% value %end% pointed by the %addr% data pointer %end%
  %inst% . %end% : write the %num% value %end% pointed by the %addr% data pointer %end% to the %blue% blue console %end%
  %inst% , %end% : read one %num% value %end% from the %green% green console %end% and write it to the position pointed by the %addr% data pointer %end%

The code is on the %gray% white console %end% . Let's use the size of the array as 20 for our project.

%blue% <+-+> %end% , and carry on.

-- Liv

ps. I know this language is useless, but saying there's a big project always make the higher ups excited, no matter how shit the project is. And trying out new languages is fun, so that's a win-win]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv8'
}
