return {
    title = "Some read command examples",
    text = [[
In case you need some further guidance, here are some examples using the %red% read %end% command and %red% conditional jumping %end% .

Example where the bot reads an input from the %orange% console %end% below him, and writes in the %orange% console %end% above him. In both cases he is using the %cyan% register #0 %end% to store the values.
    - %red% read %cyan% 0 %pink% down %end%
      %red% write %green% [0] %pink% up %end%

Example where the bot will keep reading the input from the %orange% console %end% to his %pink% left %end% ( %pink% west %end% ) until it equals the input he got from the %orange% console %end% to his %pink% right %end% ( %pink% east %end% ). Then he will be able to walk %pink% down %end% .
    - %red% read %cyan% 0 %pink% east %end%
      %purple% marv: %red% read %green% 1 %pink% west %end%
      %red% jne %green% [0] [1] %purple% marv %end%
      %red% walk %pink% down %end%

With the %red% read %end% command you can read inputs from the %orange% consoles %end% , while with the %red% write %end% you can output to the %orange% consoles %end% .

Use the %red% conditional jumps %end% to make logical loops for your programs. Understanding all this is essencial for every member of our company.

Follow you dreams, and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
