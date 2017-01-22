return {
    title = "BIG project",
    text = [[
Hey! Exciting new project coming up, and I put you on the center of it. We up here are gonna start 'researching' brainfuck. If you're not aware, brainfuck is a simple esoteric programming language.

Here's what's gonna happen: you're gonna write the interpreter, using L++, we here at software are gonna start testing what we can do with the language.

If you still don't know this language, let me give you the basics: you have a big circular array (after the last element is the first), and there is always a data pointer pointing to some position of that array. It starts on position 0, and all values are initialized to 0. Commands usually change this pointers or the contents of the pointed array position. Pretty easy, huh?

For now, just implement the simple instructions:
  >: increment (increase by one) the data pointer
  <: decrement (decrease by one) the data pointer
  +: increment the value pointed by the data pointer
  -: decrement the value pointed by the data pointer
  .: write the value pointed by the data pointer to the blue console
  ,: read one value from the green console and write it to the position pointed by the data pointer

The code is on the white console. Let's use the size of the array as 20 for our project.

<+-+>, and carry on.

-- Liv

ps. I know this language is useless, but saying there's a big project always make the higher ups excited, no matter how shit the project is. And trying out new languages is fun, so that's a win-win]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'livbf1'
}
