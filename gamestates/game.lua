local Color = require "classes.color.color"

local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"
local LoreManager = require "classes.lore-manager"
PopManager = require "classes.popmanager"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box
local room

-- DONT USE LEAVE BEFORE FIXING THIS
function state:enter()

    room = Rooms.create()
    pc_box = PcBox.create()

    LoreManager.begin()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)
    room:update(dt)
    StepManager:update(dt)
    LoreManager.update(dt)

    Util.updateTimers(dt)
end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)
    if EVENTS_LOCK then return end

    local m
    if key == 'f2' then
        Mail.new("Hey, wanna meet some hotties??", "Sonic's birthday is coming up, but the gifts he might recieve aren't what he really wants. All he wants is his childhood friend and her love. Cream and Rouge make this possible. But what happened... Well, let's just say it fits the poem the older kids sanged. 'Roses are red, Lemons are sour, open your legs and give me an hour.'", "Jenny", true)
    elseif key == 'f3' then
        m = Mail.new("So I heard you like chinchilas well I have some goodnew for you then", "They opened a door a revealed a fashionable pink and white living room with mixings of blue, they sat down and Amy leaned back as Rouge did so as well as she got out some Caramel flavoured Mud shakes, she handed one to Amy who undone the top and took a sip from the bottle 'Hmm, yumm!'' Amy said as she giggled again Rouge also giggled 'Hmm, yes very yum!'' they both giggled insanely at their incredibly unfunny jokes, Amy began stroking Rouges hair 'Rouge, have I ever told you, how beautiful you are?'' Rouge giggled and shook her head 'Not recently, no!' They laughed, Amy put her bottle on the table as she became a gigantic dinossaur and ayad ada d asad sd a sd asd fsad fas dfasdf sadf asdf asdf asdf asdf asdf asdf asd fasd fasdf asdfasdf asdf asdf asdf asdf asdf asdf a fdas dfa sdfas dfasd fasdf as df asdf asdf asdfasdf asdf asdf asdfasdfasd f", "Jason from Heavy Rain", true, function() print("you replied"); Mail.disableReply(m.number) end)
    elseif key == 'f4' then
        StepManager:play()
    elseif key == 'f6' then
        StepManager:pause()
    elseif key == 'f7' then
        StepManager:fast()
    elseif key ==  'f5' then
        Mail.new("TOP SECRET EMAIL", "This email cant be deleted. Its top priority. Oh yes", "Security", false)
    elseif key == 'f8' then
        PopManager.new("ENHANCE YOUR PERFORMANCE", "IS this the end of VIAGRA? INCREASE your girth"
            .." and size NOW. With LESS THAN 50$ guaranteed satisfaction of your partner. CLICK"
            .." to get YOURS now. Details apply ENJOY a better sex life now! __ONLY__ 50$ with one"
            .." CLICK. START NOW!!!", Color.red(), {
                func = function()
                    print("Your size has increased.")
                end, text = "MAKE ME BIG", clr = Color.blue()}, {
                func = function()
                    print("You remain small.")
                end, text = "remain small", clr = Color.red()})
    elseif key == 'f9' then
        room.grid_obj[19][19]:toggleClients()
    elseif key == 'f10' then
        -- REMOVE
        ALL_OK = true
    elseif key == 'f11' then
    code =
[=[
walk up
walk left
lp: read 0
read 1
read 2
beg: mov 4 0
mov 5 1
jgt [0] [1] swp


swp: mov 6 [[4]]
mov [4] [[5]]
mov [5] [6]
jmp beg
]=]
    for i = 1, #code do
        if code:sub(i, i) == '\n' then
            state:keypressed('return')
        else
            state:textinput(code:sub(i,i))
        end
    end
    else
        Util.defaultKeyPressed(key)
        pc_box:keyPressed(key)
        room:keyPressed(key)
    end

end

function state:mousepressed(x, y, but)
    if EVENTS_LOCK then return end

    pc_box:mousePressed(x,y,but)

end

function state:mousereleased(x, y, button, touch)
    PopManager.mousereleased(x, y, button, touch)
end

function state:textinput(t)
    if EVENTS_LOCK then return end

    pc_box:textInput(t)
end

function state:wheelmoved(x, y)
    if EVENTS_LOCK then return end

    pc_box:mouseScroll(x, y)
end

--Return state functions
return state
