local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box
local room

function state:enter()
    room = Rooms.create()
    pc_box = PcBox.create()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)

    Util.updateTimers(dt)
end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)

    if key == 'f2' then
        Mail.new("Hey, wanna meet some hotties??", "Sonic's birthday is coming up, but the gifts he might recieve aren't what he really wants. All he wants is his childhood friend and her love. Cream and Rouge make this possible. But what happened... Well, let's just say it fits the poem the older kids sanged. 'Roses are red, Lemons are sour, open your legs and give me an hour.'", "Jenny")
    elseif key == 'f3' then
        Mail.new("So I heard you like chinchilas well I have some goodnew for you then", "They opened a door a revealed a fashionable pink and white living room with mixings of blue, they sat down and Amy leaned back as Rouge did so as well as she got out some Caramel flavoured Mud shakes, she handed one to Amy who undone the top and took a sip from the bottle 'Hmm, yumm!'' Amy said as she giggled again Rouge also giggled 'Hmm, yes very yum!'' they both giggled insanely at their incredibly unfunny jokes, Amy began stroking Rouges hair 'Rouge, have I ever told you, how beautiful you are?'' Rouge giggled and shook her head 'Not recently, no!' They laughed, Amy put her bottle on the table as she became a gigantic dinossaur", "Jason from Heavy Rain")
    else
        Util.defaultKeyPressed(key)
        pc_box:keyPressed(key)
    end

end

function state:mousepressed(x, y, but)

    pc_box:mousePressed(x,y,but)

end

function state:textinput(t)
    pc_box:textInput(t)
end

--Return state functions
return state
