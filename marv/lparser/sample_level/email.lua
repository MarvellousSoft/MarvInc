-- This is a sample email script.
-- We showcase how to write your own puzzles and emails.

-- DISCLAIMER:
-- Before we start, we would like to give out a warning. Puzzles are made by the community, and not
-- the developers, meaning we are not responsible for any deaths, injuries or damages to you or
-- your loved ones (this includes your PC) in case you decide running some sketchy guy's puzzle
-- script. In fact, we highly recommend you scanning over any community puzzle for malicious code.
-- Of course, the art of code obfuscation is a pathway many would consider unnatural, so sometimes
-- just looking through one's code may not reveal anything. In order to prevent any of this naughty
-- business, we give out these three do's and three don'ts for anyone who writes puzzles for
-- MarvInc:
--  1. Do document your code (so people know what they're running on their machines).
--  2. Do have fun writing your puzzle.
--  3. Do give support for those who play your puzzle.
--  4. Don't obfuscate code.
--  5. Don't falsely advertise what your puzzle does (this just raises suspicions on your code).
--  6. Don't be a dick.
-- If everyone followed these rules, the world would be a better place. So make the world better.

-- We call a Level Script (LS for short) a .lua file that contains a puzzle. We call an Email
-- Script (ES) a .lua file that contains an email that should trigger the puzzle. Another sample
-- .lua named email_sample.lua can be found in this same directory explaining how to create your
-- Email Script.

-- A custom puzzle file structure should be as follows. Let / (root) directory be where MarvInc
-- stores its user data (for Windows that'd be AppData, on Linux ~/.local/share/love/marvellous/).
--
-- /
-- *- custom/
-- *--*-- my_puzzle/
-- *--*--*-- level.lua
-- *--*--*-- email.lua
-- *--*--*-- assets/
-- *--*--*--*-- my_tile.png
-- *--*--*--*-- my_image.png
-- *--*--*--*-- my_sprite.png
--
-- Directory /custom/ is where custom puzzles should be stored. Each puzzle should have its own
-- directory with a unique name. Inside each puzzle directory, two .lua files should be present.
-- The first, level.lua is the Level Script. The second, email.lua is the Email Script. Any assets
-- should be inside your puzzle directory. How you're going to name them, or where they're going to
-- be located inside this directory is up to you. Just recall that when importing assets, you
-- should tell the parser its relative path in relation to your puzzle directory. So in the above
-- example, you should import my_image.png through the relative path "assets/my_image.png".

-- EMAIL SCRIPT

-- Writing an email script is not a requirement for creating your own puzzles. All custom levels
-- put inside your local custom levels directory will be available to play through the Puzzles tab
-- under Custom.
--
-- However, writing your own emails gives your puzzles their own personality. You get the chance to
-- create exciting new stories and characters, making your levels much more attractive.

Email.SetTitle "Email subject."
Email.SetText [[
This is the body of the email. You can use {green}tags{end} to give {pink}f{gray}l{blue}a{purple}i{orange}r{end} and {cyan}color{end} to your emails.

You may also add {red}one{end} (and only one) image to your email. For this use self.Attach.
]]

-- Attaches image to main email.
Email.SetAttachment "example.png"

--[[
Below is a list of tags you can use on the body of your email to change the text color.
    {end} - Stop previous tag and start using default_color
    {red} - Red color
    {blue} - Blue color
    {green} - Green color
    {purple} - Purple color
    {orange} - Orange color
    {cyan} - Cyan color
    {pink} - Pink color
    {gray} - Gray color
    {brown} - Brown color
    {inst} - Used for instructions
    {dir} - Used for directions
    {lab} - Used for labels
    {num} - Used for values
    {addr} - Used for addresses
    {cmnt} - Used for comments
    {ds} - Used when mentioning data structures
    {tab} - Used for pc-box tabs
]]

-- Author lists the authors of the email.
Email.SetAuthors "Jerome Jebediah Jenkins Junior II (j42@marv.com)"

-- Your email sender may also have a portrait of themselves.
Email.SetPortrait "j42.png"