--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

VERSION = "1.2.1"

--GLOBAL VARIABLES--
W = love.graphics.getWidth() --Current width of the game window
H = love.graphics.getHeight() --Current height of the game window

ROWS = 21
COLS = 21

WIN_BORD = 20

-- End of turn signal
SIGEND = "end_turn"

--FONTS--

--Fira-mono regular font table
FIRA = {}
--Fira-mono bold font table
FIRA_BOLD = {}
--Roboto regular font table
ROBOTO = {}
--Roboto bold font table
ROBOTO_BOLD = {}
--Roboto thin font table
ROBOTO_LIGHT = {}
--Global fonts table
local fonts = {
    fira = "assets/fonts/fira-mono-regular.ttf",
    firaBold = "assets/fonts/fira-mono-bold.ttf",
    roboto = "assets/fonts/Roboto-Regular.ttf",
    robotoBold = "assets/fonts/Roboto-Bold.ttf",
    robotoLight = "assets/fonts/Roboto-Light.ttf",
    comfortaa = "assets/fonts/Comfortaa-Regular.ttf",
    comfortaaBold = "assets/fonts/Comfortaa-Bold.ttf",
    comfortaaLight = "assets/fonts/Comfortaa-Light.ttf",
}

FONTS = {}

for name, file in pairs(fonts) do
    local stored = {}
    FONTS[name] = function(size)
        if not stored[size] then
            stored[size] = love.graphics.newFont(file, size)
        end
        return stored[size]
    end
end

--Other Tables
SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
ID_TABLE = {} --Table with elements with Ids (for fast lookup)

-- Buttons Images
BUTS_IMG = {}
BUTS_IMG["play"] = love.graphics.newImage("assets/images/button_play.png")
BUTS_IMG["fast"] = love.graphics.newImage("assets/images/button_fast.png")
BUTS_IMG["fast_blocked"] = love.graphics.newImage("assets/images/button_fast_blocked.png")
BUTS_IMG["superfast"] = love.graphics.newImage("assets/images/button_superfast.png")
BUTS_IMG["superfast_blocked"] = love.graphics.newImage("assets/images/button_superfast_blocked.png")
BUTS_IMG["pause"] = love.graphics.newImage("assets/images/button_pause.png")
BUTS_IMG["pause_blocked"] = love.graphics.newImage("assets/images/button_pause_blocked.png")
BUTS_IMG["stop"] = love.graphics.newImage("assets/images/button_stop.png")
BUTS_IMG["stop_blocked"] = love.graphics.newImage("assets/images/button_stop_blocked.png")
BUTS_IMG["step"] = love.graphics.newImage("assets/images/button_step.png")
BUTS_IMG["logoff"] = love.graphics.newImage("assets/images/logoff_button_regular.png")
BUTS_IMG["logoff_hover"] = love.graphics.newImage("assets/images/logoff_button_mouse_over.png")
BUTS_IMG["settings"] = love.graphics.newImage("assets/images/settings.png")

-- Move orientations
NORTH, EAST = Vector.new(0, -1), Vector.new(1, 0)
SOUTH, WEST = Vector.new(0, 1), Vector.new(-1, 0)
ORIENT = {NORTH, EAST, SOUTH, WEST}


--TIMERS--
MAIN_TIMER = Timer.new()  --General Timer
AUDIO_TIMER = Timer.new()  --General Audio Timer

-- Rotational orientations
NORTH_R, EAST_R, SOUTH_R, WEST_R = {math.pi}, {3*math.pi/2}, {0}, {math.pi/2}
ORIENT_R = {NORTH_R, EAST_R, SOUTH_R, WEST_R}
for i=1, #ORIENT_R do
    ORIENT_R[i][2] = i
end

--IMAGES--

-- Tiles
TILES_IMG = {}
TILES_IMG["white_floor"] = love.graphics.newImage("assets/images/white_tile.png")
TILES_IMG["building_floor"] = love.graphics.newImage("assets/images/building_floor.png")
TILES_IMG["black_floor"] = love.graphics.newImage("assets/images/black_tile.png")
TILES_IMG["grey_tile"] = love.graphics.newImage("assets/images/grey_tile.png")
TILES_IMG["red_tile"] = love.graphics.newImage("assets/images/red_tile.png")
TILES_IMG["green_tile"] = love.graphics.newImage("assets/images/green_tile.png")
TILES_IMG["blue_tile"] = love.graphics.newImage("assets/images/blue_tile.png")
TILES_IMG["solid_lava"] = love.graphics.newImage("assets/images/cold_lava_tile.png")
TILES_IMG["blood_splat_1"] = love.graphics.newImage("assets/images/blood_splat_1.png")
TILES_IMG["blood_splat_2"] = love.graphics.newImage("assets/images/blood_splat_2.png")
TILES_IMG["blood_splat_3"] = love.graphics.newImage("assets/images/blood_splat_3.png")
TILES_IMG["blood_splat_4"] = love.graphics.newImage("assets/images/blood_splat_4.png")

-- Objects
OBJS_IMG = {}
OBJS_IMG["wall_none"] = love.graphics.newImage("assets/images/wall_none.png")
OBJS_IMG["building_wall"] = love.graphics.newImage("assets/images/building_wall.png")
OBJS_IMG["building_outside"] = love.graphics.newImage("assets/images/building_outside.png")
OBJS_IMG["building_window"] = love.graphics.newImage("assets/images/building_window.png")
OBJS_IMG["building_corner"] = love.graphics.newImage("assets/images/building_wall_corner.png")
OBJS_IMG["building_inner"] = love.graphics.newImage("assets/images/building_innerwall.png")
OBJS_IMG["wall_o"] = love.graphics.newImage("assets/images/wall_o.png")
OBJS_IMG["black_block"] = love.graphics.newImage("assets/images/black_tile.png")
OBJS_IMG["red_tile"] = TILES_IMG.red_tile
OBJS_IMG["green_tile"] = TILES_IMG.green_tile
OBJS_IMG["blue_tile"] = TILES_IMG.blue_tile
OBJS_IMG["bucket"] = love.graphics.newImage("assets/images/bucket.png")
OBJS_IMG["bucket_content"] = love.graphics.newImage("assets/images/bucket_content.png")
OBJS_IMG["console"] = love.graphics.newImage("assets/images/console.png")
OBJS_IMG["emitter"] = love.graphics.newImage("assets/images/emitter.png")
OBJS_IMG["papers"] = love.graphics.newImage("assets/images/papers.png")
OBJS_IMG["table"] = love.graphics.newImage("assets/images/fancy_table.png")
OBJS_IMG["cloud_1"] = love.graphics.newImage("assets/images/cloud_1.png")

OBJS_IMG["dead_body1"] = love.graphics.newImage("assets/images/dead_body_1.png")
OBJS_IMG["dead_body2"] = love.graphics.newImage("assets/images/dead_body_2.png")
OBJS_IMG["dead_body3"] = love.graphics.newImage("assets/images/dead_body_3.png")
OBJS_IMG["dead_body_hair"] = love.graphics.newImage("assets/images/dead_hair_1.png")

-- Character colors
Color = require "classes.color.color"
CHR_CLR = {}
CHR_CLR['bm'] = Color.yellow()
CHR_CLR['diego'] = Color.pink()
CHR_CLR['fergus'] = Color.brown()
CHR_CLR['franz'] = Color.gray()
CHR_CLR['jen'] = Color.red()
CHR_CLR['hr'] = Color.gray()
CHR_CLR['liv'] = Color.purple()
CHR_CLR['paul'] = Color.green()
CHR_CLR['auto'] = Color.orange()
CHR_CLR['human'] = Color.blue()
CHR_CLR['news'] = Color.teal()
CHR_CLR['emergency'] = Color.magenta()
CHR_CLR['ryr'] = Color.add3(Color.blue(), Color.purple(), Color.orange())
CHR_CLR['spam'] = Color.violet()
CHR_CLR['black'] = Color.black()

-- Spritesheets
SHEET_IMG = {}
SHEET_IMG["ray"] = {love.graphics.newImage("assets/images/ray_sheet.png"), 2}
SHEET_IMG["lava"] = {love.graphics.newImage("assets/images/lava_sheet.png"), 4}
SHEET_IMG["paint"] = {love.graphics.newImage("assets/images/paint_sheet.png"), 4}
SHEET_IMG["fireplace"] = {love.graphics.newImage("assets/images/fireplace_sheet.png"), 6}

-- Author Images
AUTHOR_IMG = {}
AUTHOR_IMG["unknown"] = love.graphics.newImage("assets/images/authors/unknown.png")
AUTHOR_IMG["liv"] = love.graphics.newImage("assets/images/authors/liv.png")
AUTHOR_IMG["fergus"] = love.graphics.newImage("assets/images/authors/fergus.png")
AUTHOR_IMG["paul"] = love.graphics.newImage("assets/images/authors/paul.png")
AUTHOR_IMG["auto"] = love.graphics.newImage("assets/images/authors/auto.png")
AUTHOR_IMG["hr"] = love.graphics.newImage("assets/images/authors/hr.png")
AUTHOR_IMG["jan"] = love.graphics.newImage("assets/images/authors/jen.png")
AUTHOR_IMG["diego"] = love.graphics.newImage("assets/images/authors/diego.png")
AUTHOR_IMG["richard"] = love.graphics.newImage("assets/images/authors/black.png")
AUTHOR_IMG["bill"] = love.graphics.newImage("assets/images/authors/bill.png")
AUTHOR_IMG["miles"] = love.graphics.newImage("assets/images/authors/miles.png")
AUTHOR_IMG["franz"] = love.graphics.newImage("assets/images/authors/franz.png")
AUTHOR_IMG["newsletter"] = love.graphics.newImage("assets/images/authors/news.png")
AUTHOR_IMG["renato"] = love.graphics.newImage("assets/images/authors/ryr.png")

-- Room Img
ROOM_CAMERA_IMG = love.graphics.newImage("assets/images/room_camera.png")
-- Background
BG_IMG = love.graphics.newImage("assets/images/background.png")

-- Miscellaneous images
MISC_IMG = {}
MISC_IMG["static"] = love.graphics.newImage("assets/images/static.png")
MISC_IMG["star"] = love.graphics.newImage("assets/images/star.png")
MISC_IMG["arrow"] = love.graphics.newImage("assets/images/arrow.png")
MISC_IMG["logo"] = love.graphics.newImage("assets/images/logo.png")
MISC_IMG["cat"] = love.graphics.newImage("assets/images/grumpy_cat.png")
MISC_IMG["marvsoft"] = love.graphics.newImage("assets/images/Marvellous Soft.png")


-- Bot images (assume array part only)
HAIR = {
    love.graphics.newImage("assets/images/hairs/01.png"),
    love.graphics.newImage("assets/images/hairs/02.png"),
    love.graphics.newImage("assets/images/hairs/03.png"),
    love.graphics.newImage("assets/images/hairs/04.png"),
    love.graphics.newImage("assets/images/hairs/05.png"),
}
HEAD = {
    love.graphics.newImage("assets/images/faces/01.png"),
}
BODY = {
    love.graphics.newImage("assets/images/bodies/01.png")
}


--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    TABS_LOCK = 0 -- If the tabs cant be clicked
    EVENTS_LOCK = 0 -- All events but popup mouse pressed are locked

    EMPLOYEE_NUMBER = love.math.random(200, 2000)

    UNREAD_EMAILS = 0 -- Number of unread emails

    -- Current room
    ROOM = nil

    NAMES = {"Barry", "Larry", "Terry", "Mary", "Fieri", "Danny", "Kenny", "Benny", "Kelly",
             "Harry", "Carie", "Perry", "Sally", "Abby", "Genny", "Figgy", "Ginnie", "Jenny",
             "Nancy", "Manny", "Ellie", "Lenny", "Ziggy", "Tammy", "Kerry", "Gerry", "Bonnie",
             "Tony", "Jammy", "Fanny", "Yammy", "Jerry", "Omarry", "Ury", "Lilly", "Nelly",
             "Annie",
            }
    --Traits table composed of tuples, where the first position is a trait, second a table containing specific dialog options for this trait and third table containing specific last words options for this trait.
    TRAITS = {
      {"has peculiar taste in pizza", {"Hawaiian pizza isn't so bad, you know?"}, {}},
      {"socially awkward", {}, {}},
      {"likes Phantom Menace", {"Jar Jar Binks is soooo underrated...", "Meesa think yousa no know how to solve thisa problem."}, {}},
      {"collects stamps", {"You know whats better than bacon? Freaking stamps man."}, {}},
      {"color blind", {"Hey, quick question. Is my hair green or red?"}, {}},
      {"puppy lover", {"Woof Woof Bark Bark :3"}, {}},
      {"arachnophobic", {"DUDE IS THAT A SPIDER IN THE CEILING?!"}, {}},
      {"lactose intolerant", {"Soy milk is the bomb."}, {}},
      {"snorts when laughing", {}, {}},
      {"germophobe", {"Please don't make me touch anything dirty."}, {}},
      {"insomniac", {}, {}},
      {"lives with mom", {}, {}},
      {"has a cool car", {"I can give you a ride someday", "Hey have I told you about my sweet Sedan? 'ts preety cool"}, {}},
      {"listens to emo rock", {}, {}},
      {"addicted to caffeine", {}, {}},
      {"explorer at heart", {}, {}},
      {"never tips", {"10% service it's just an absurd, don't you think?"}, {}},
      {"jerk", {"You're ugly.", "F%$# you."}, {"F%$# you."}},
      {"sympathetic", {"Don't stress man, take your time. :)", "These puzzles sure are tough huh?"}, {"It's ok, man. We had a good run..."}},
      {"funny", {"You know the worst part of being lonely here? I can't up my frisbee game."}, {}},
      {"cool", {}, {"Ain't no thing, brother. You did what you had to do."}},
      {"11 toes", {}, {}},
      {"speaks in jive", {"Y'all cats better know what's up with this shit, aight?", "I'm thinkin' ya ain't got the chops for this, ya dig?"}, {"You done fucked me up, son!"}},
      {"logical", {"Don't stress. Stressing doesn't help you achieve your objective."}, {}},
      {"irrational", {}, {}},
      {"creepy", {"I can hear your breathing from here...:)", "You smell good today. Is that because of the new shampoo you bought yesterday?"}, {}},
      {"good cook", {}, {}},
      {"liked LOST's ending", {"Hurley was the best character in a TV show by far.", "IT WAS ALL CYCLIC.", "Man, don't believe the haters about LOST's ending.", "See you in another life, brotha."}, {}},
      {"bought an Ouya", {"Life is made of regrets..."}, {"I have only one regret in my short life! Buying an Ouya..."}},
      {"hates tennis", {"Federer is a fool and probably has stinky feet."}, {}},
      {"has heterochromia", {"My left eye is reddish. My right one is blueish. And no, I do not see purple."}, {}},
      {"artistic", {}, {}},
      {"smells", {}, {}},
      {"inconvenient", {"Hey, what are you doing there?", "Do you really need that command?", "Are you done yet?", "Are you done yet?"}, {}},
      {"hates sports", {}, {}},
      {"soccer fan", {"Did you see that ludicrous display last night?"}, {}},
      {"uses hashtags", {"#NailingIt", "#YouCanDoIt", "#NoFilter"}, {"#TimeToDie", "#ThisIsGonnaSuck"}},
      {"rad dance moves", {}, {}},
      {"types with just one finger", {}, {}},
      {"has a russian accent", {}, {"Goodbye, tovarisch."}},
      {"eats M&Ms by color", {"Usually I start with the reds and follow the rainbow order."}, {}},
      {"obsessed with Michael Cera", {"Michael Cera is just the perfect actor.", "Have you watched Arrested Development?", "Have you watched Juno?", "Michael Cera's mustache is the symbol of masculinity.", "Have you watched Scott Pilgrim?", "Have you watched Superbad?", "The best thing about Michael Cera is he doesn't even need to act."}, {}},
      {"obsessed with Nicolas Cage", {"Nicolas Cage is just the perfect actor.", "Have you watched Face/Off?", "Have you watched Kick-Ass? Man that Nic Cage scene.", "Have you watched Bad Lieutenant?"}, {}},
      {"eats toothpaste", {}, {}},
      {"grammer nazi", {"Actually, it's 'grammar nazi'."}, {}},
      {"collects purple kilts", {}, {}},
      {"very rosy cheeks", {}, {}},
      {"eats fingernails", {}, {}},
      {"hears voices", {"DON'T TELL ME WHAT TO DO", "Of course not.", "Hahaha, no. That would be silly", "What?", "Why?", "Okay okay! I'll do it! Just shut up!"}, {"They warned me! They warned me not to trust you!"}},
      {"terribly shy", {"...", "please... don't...", "*looks away*"}, {"...oh no..."}},
      {"blinks furiously when lying", {}, {}},
      {"memorized Moby Dick", {}, {}},
      {"lost an eye in a bear accident", {"An eye for an eye... That bear sure showed me."}, {}},
      {"hates bears", {"Goddamn bears stealing our honeykeeping jobs!"}, {}},
      {"never finished a game without a walkthrough", {"You should look for the solution to this puzzle on the internet!"}, {}},
      {"overachiever", {}, {}},
      {"underachiever", {}, {}},
      {"always drunk", {"Jsut one moer drink..."}, {}},
      {"addicted to HIMYM", {"This puzzle is LEGEN --wait for it-- DARY!! hahaha"}, {}},
      {"vegan without the powers", {}, {}},
      {"has to touch everything", {}, {}},
      {"has OCD", {}, {}},
      {"class clown", {}, {}},
      {"in a relationship with a pet rock", {}, {}},
      {"literally allergic to bad jokes", {}, {}},
      {"terrified of babies", {}, {}},
      {"picks scabs", {}, {}},
      {"pretends is a mime at parties", {}, {}},
      {"proud believer of crab people", {}, {}},
      {"reads minds", {"This puzzle is not a pain in the ass. Stop thinking that."}, {"It's ok. I forgive you."}},
      {"can play the theremin", {}, {}},
      {"can recite the alphabet backwards perfectly", {"This puzzle is easy as ZYX :)"}, {}},
      {"loves costume parties", {}, {}},
      {"can correctly give current latitude and longitude at all times", {}, {}},
      {"accidently makes sexual innuendos", {"This is too hard and long! I can't take it anymore. Just finish already!"}, {}},
      {"has a catchphrase", {"Wubba lubba dub dub", "Wubba lubba dub dub", "Wubba lubba dub dub", "AIDS!",  "Ands that's the wayyyyy the news goes!", "GRASSSS... tastes bad!", "Lick, lick, lick my BALLS!"}, {}},
      {"has an unhealthy obession with Kermit the Frog", {}, {}},
      {"can't ride a bike", {}, {}},
      {"is always seen wearing pajamas", {}, {}},
      {"afraid of the internet", {"They say you can catch a virus in this Internet!"}, {}},
      {"is agressively against socks", {}, {}},
      {"speaks in a monotone voice", {}, {}},
      {"born in a leap year", {"I'm turning 6 today. :P"}, {}},
      {"slow walker", {}, {}},
      {"never showers", {"I prefer to think I'm SAVING our precious planet's resource"}, {}},
      {"sweats profusely", {"Oh man, did someone up the heat? I'm feeling like a pig down here."}, {}},
      {"chews ice cubes for dinner", {}, {}},
      {"heavy sleeper", {}, {}},
      {"fear of closed doors", {"I don't care about lava or buckets, just don't leave any door closed okay?", "Lets leave all door open, please."}, {}},
      {"stores their urine in a jar", {"Everyone has a hobby :)"}, {}},
      {"kleptomaniac", {"Can I borrow your computer when I leave this place?"}, {}},
      {"only watches SpongeBob reruns", {"How about that one where Squidward accidentally freezes himself for 2,000 years huh? Classic!","Have you seen the one where Patrick helps SpongeBob on his driving test? Oh man I love that one!"}, {}},
      {"constantly makes animal noises", {"Moo", "Oink Oink","Baaaaaaah", "Meeeoow ;3", "Gobble gobble gobble"}, {}},
      {"afraid of feet", {}, {}},
      {"has a foot fetish", {"Could you describe your feet for me? ;)"}, {}},
      {"TYPES IN ALL CAPS", {"HEY MAN U DOING ALRIGHT THERE?"}, {"I'M GOING TO DIE!!!"}},
      {"know it all", {"Did you know a crocodile can't poke its tongue out?"}, {}},
      {"has bad acne", {"Please don't look at my face, I'm very insecure about it..."}, {}},
      {"conspiracy theorist", {"9/11 was an inside job.", "Illuminati are behind it all.", "Vaccination is a lie created by the media.", "We're all being mind-controlled!"}, {}},
      {"nihilist", {"This puzzle doesn't matter. Nothing does."}, {"Death is meaningless."}},
      {"ArchLinux user", {"Did I tell you I run ArchLinux?", "Yesterday I managed to connect to a Wi-Fi network. I know, super hard."}, {}},
      {"plays Dwarf Fortress", {}, {"Death is all around us, begone fear!"}},
      {"Apple fanboy", {"The new iPhone isn't really that expensive... I'll just take a second mortgage..."}, {}},
      {"Elvis impersonator", {"Yeah baby yeah...", "I guess this \"robot\" microchip is... Always on my mind, baby."}, {}},
      {"has the Disco Fever", {"The boogie's gonna start to explode any time now, baby...", "I'm gettin' loose y'all!", "Gotta fight with expert timing, baby!", "Gotta feel the city breakin' and everybody shakin'!", "I'm stayin' alive!", "Baby, that's the way, uh-huh uh-huh, I like it!", "Let's get the boogie started!", "Let's do the Freak! I've heard it's quite chic!", "Do you remember the 21st of September?", "Baby, give it up! Give it up, baby give it up!"}, {}},
      {"1/128 irish", {"I can't wait for St. Pattys day!"}, {}},
      {"german", {"Das ist nicht effizient. You should optimize your code."}, {}},
      {"spanish", {"Oye chico! When I can do the siesta, eh?"}, {}},
      {"hypochondriac", {"Oh man, I'm not feeling really well...", "Was this bruise here before?! Shit! It could be rhabdomyolysis!", "Feeling a little dizzy..."}, {"I literally feel like I'm dying, man!"}},
      {"game developer", {"Art of Game Design is the best book ever written!", "Let's make a Game Design Document to solve this!"}, {}},
      {"never-nude", {"There are dozens of us!"}, {}},
      {"magician", {"It's not a trick. It's an ILLUSION.", "You like magic? SAME", "But where did the lighter fluid come from?"}, {"Want to see a cool trick?"}},
      {"ambidextrous", {}, {}},
      {"left-handed", {}, {}},
      {"procrastinator", {"Why don't you solve another puzzle?", "You should watch some TV first... Just to unwind."}, {}},
      {"national spelling bee winner", {"You are D-E-F-I-N-I-T-E-L-Y solving this task."}, {"D-E-A-D"}},
      {"frugal", {}, {}},
      {"freakishly tall", {}, {}},
      {"went to Burning Man", {"Have I told you how awesome it was at Burning Man?!", "I'm telling you, Burning Man is eye-opening!"}, {}},
      {"gambling addict", {"I bet 5$ you can't finish this task in under 5 minutes."}, {"I bet this will hurt a lot."}},
      {"diabetic", {}, {}},
      {"only drinks soda", {"Juice is for vegans man. Soda, that's where it's at."}, {}},
      {"only listens to Insane Clown Posse", {}, {}},
      {"thinks it's a pirate", {"Yaaaaaaaarrrrr"}, {"Arr, my scallywag, ya done kill me for good!"}},
      {"game of thrones fanboy", {"KHALEESI", "WHERE ARE MY DRAGONS?", "Winter is coming!!", "The red wedding was rad, right?"}, {}},
      {"believes in pc master race", {"Can you run 16K 180 FPS in your console?"}, {}},
      {"likes new technologies", {"Have you bought bitcoin yet?", "VR is the future!", "Augmented Reality is here to stay."}, {}},
      {"watches youtube hits", {"OPPA GANGNAM STYLE", "TURN DOWN FOR WHAT?", "DO THE HARLEM SHAKE"}, {}},
      {"meme guy", {"*trollface*", "Forever Alone."}, {}},
      {"lana del rey fan", {"You want to be my sugar daddy?", "*smokes*"}, {}},
      {"likes small talk", {"What a weather, huh?"}, {}},
    }

    --Regular dialogs any robot can say
    REGULAR_DIALOGS = {
      "This one seems pretty straight forward.",
      "Hey how are things going?",
      "Nice day right? I mean, I'm really asking, can't see a thing from here.",
      "Taking your time huh?",
      "Please move this along.",
      "Can you go a little faster there mate?",
      "All I wanted was a hug...",
      "Try not to kill me please.",
      "This looks more challenging that I thought.",
      "Can you finish this one before I fall asleep?",
      "How long have you been on this task?",
      "Any progress?",
      "HA! I figured it out!\n\n...but I'm not telling you.",
      "I don't like where this is going.",
      "Please debug your code before running it with me.",
      "...",
      "It's a bit chill here.",
      "My legs are sore, try not to make me walk much.",
      "*yawns*",
      "ATCHOO",
      "What are you doing?",
      "This is hopeless. Just try another task.",
      "Is there a 'dance' command?",
      "Can you make me somersault?",
      "What can I do for you?",
      "Where's the afterparty at?",
      "Let me know if you need anything.",
      "All my hopes lie with you.",
      "I trust you.",
      "I'm hungry.",
      "I'm tired.",
      "Staying still is a bit boring.",
      "Don't let me down.",
      "Is this hard?",
    }

    --Introduction dialogs any robot can say once, where {bot_name} will be replaced by its name
    INTRO_DIALOGS = {
      "Hello, my name is {bot_name}.",
      "{bot_name}. Nice to meet you.",
      "Bot {bot_name} waiting your instructions.",
      "Sup.",
      "Hey there, looks like we'll be stuck together for a while :)",
      "{bot_name} is my name. Serving you is my game ;)",
      "I hope you don't kill me like the last one...",
      "Hi buddy!",
      "Yo",
      "Hey man.",
      "Hello.",
      "You can call me {bot_name}.",
      "Hey I'm {bot_name}. Let's solve this.",
      "Let's hope I don't end the same way as the other robots, ok?",
      "My name is {bot_name} and we are now best friends!",
      "Is this freedom?!!...oh, it's just another puzzle :(",
    }

    --FAILED POPUP MESSAGES TABLES
    FAILED_POPUP_MESSAGES = {
      code_over =
      {
        title = "Code not successful",
        sentences =
        {
            "Your code finished but the objectives weren't completed. Your robot had to be sacrificed as punishment for your inefficiency.",
            "Your code reached the ending but you did not fully meet the objectives. So we exploded your bot. Do not repeat this mistake."
        }
      },
      paint_container =
      {
        title = "Bot drowned in paint!",
        sentences =
        {
            "You somehow let your bot fall into a paint container. That's embarassing.",
            "It seems you let your bot fall into a paint container... Did you do that on purpose?",
            "Your robot sunk into a beautiful rainbow.",
        }
      },
      lava =
      {
        title = "Bot burn in lava!",
        sentences =
        {
            "You let your bot burn in hot lava. That's innapropriate.",
            "Your bot scorched to death.",
            "Your robot fell in a lava pit. I don't think it's coming back.",
            "Your robot got head first in a lava pit.",

        }
      },
      laser =
      {
        title = "Bot destroyed by laser!",
        sentences =
        {
            "Your bot got in a direct conflict with a laser ray. The laser won.",
            "Your robot was obliterated by a laser.",
            "Your robot was sliced in half by a laser."
        }
      },
    }
    --Table of different apologise texts it can appear on failed popups
    FAILED_POPUP_BUTTON_TEXT =
    {
      " I'm sorry ",
      " I will be more careful next time ",
      " Frankly it was his fault ",
      " It won't happen again ",
      " Ooops ",
      " I will be more successful next time ",
    }

    REGULAR_DYING_MESSAGES =
    {
      "AAAAAaaaaAAAaaaAAAaaaAAaAAAaAAaAAAaaAAAAAaaaaAAAAaaaaAAAaaaAAaAAAaaA",
      "Hey did you know today is my birthd-",
      "Argh!",
      "Wait, is that?! Oh shit!",
      "Oh no, shit! Argh!",
      "WHAT THE FUCK?!",
      "#YOLO"
    }

    --INITIALIZING TABLES--

    --Drawing Tables
    DRAW_TABLE = {
    BG   = {}, --Background (bottom layer, first to draw)
    L1   = {}, --Layer 1
    L1u  = {}, --Layer 1 upper
    L2   = {}, --Layer 2
    GUI  = {}  --Graphic User Interface (top layer, last to draw)
    }

    --WINDOW CONFIG--
    love.window.setMode(W, H, {resizable = true, minwidth = 800, minheight = 600})
    ResManager.init()
    ResManager.adjustWindow(W, H)

    --CAMERA--
    CAM = Camera(W/2, H/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--
    SOUND_EFFECT_MOD = 1 -- Current effects volume
    SFX = {}
    SFX.loud_static = SoundEffect("assets/sound/pink_noise.wav", "static", 1, true)
    SFX.tab_switch = SoundEffect("assets/sound/tab_switch.ogg", "static")
    SFX.new_email = SoundEffect("assets/sound/new_email.wav", "static", .5)
    SFX.buzz = SoundEffect("assets/sound/buzz.ogg", "static")
    SFX.fail = SoundEffect("assets/sound/fail.mp3", "static")
    SFX.click = SoundEffect("assets/sound/click.wav", "static")
    SFX.side_message = SoundEffect("assets/sound/side_message_blip.wav", "static")
    SFX.login = SoundEffect("assets/sound/login.wav", "static")
    SFX.open_email = SoundEffect("assets/sound/open_email.wav", "static")
    SFX.close_email = SoundEffect("assets/sound/close_email.wav", "static")
    SFX.win_puzzle = SoundEffect("assets/sound/win_puzzle.wav", "static")

    MUSIC_MOD = 1 -- Current BGM volume
    MUSIC = {}
    MUSIC.menu = {path = "assets/sound/bgms/tumult.mp3"}
    MUSIC.tut_1 = {path = "assets/sound/bgms/he_missed_loop.mp3"}
    MUSIC.tut_2 = {path = "assets/sound/bgms/easy_life_loop.mp3"}
    MUSIC.act1_1 = {path = "assets/sound/bgms/what_have_you_done_loop.mp3"}
    MUSIC.act2_1 = {path = "assets/sound/bgms/tiger_blue_sky_loop.mp3"}
    MUSIC.act2_2 = {path = "assets/sound/bgms/wasnt_what_i_expected_loop.mp3"}
    MUSIC.act2_3 = {path = "assets/sound/bgms/i_wanted_to_live_loop.mp3"}
    MUSIC.act3_1 = {path = "assets/sound/bgms/i_thought_of_pills_loop.mp3"}
    MUSIC.act3_2 = {path = "assets/sound/bgms/just_blue_sky_loop.mp3"}
    MUSIC.act3_3 = {path = "assets/sound/bgms/completely_lost_loop.mp3"}
    MUSIC.final_puzzle = {path = "assets/sound/bgms/a_role_in_life_loop.mp3"}
    local music_vol_reg = .5
    for _, m in pairs(MUSIC) do
        m.base_volume = music_vol_reg
    end
end

--Return functions
return setup
