--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"
Signal    = require "hump.signal"

--MY MODULES
Util      = require "util"
Draw      = require "draw"
Setup     = require "setup"

--CLASSES

require "classes.primitive"

require "classes.color.rgb"
require "classes.color.hsl"
require "classes.color.color"

But = require "classes.button"

require "classes.tabs.tab"
Mail = require "classes.tabs.email"
require "classes.tabs.code"
require "classes.tabs.info"

require "classes.pc_box"
require "classes.sprite"
require "classes.sprite_object"
require "classes.object"
require "classes.obstacle"
require "classes.dead"
require "classes.bucket"
require "classes.dead_switch"
require "classes.emitter"
require "classes.bot"
require "classes.puzzle"
require "classes.room"
require "classes.opened_email"
Color = require "classes.color.color"
FX = require "classes.fx"
StepManager = require "classes.step_manager"
LoreManager = require "classes.lore_manager"
PopManager  = require "classes.pop_manager"
SaveManager = require "save_manager"
ResManager = require "res_manager"

--GAMESTATES
GS = {
MENU     = require "gamestates.menu",     --Menu Gamestate
GAME     = require "gamestates.game",     --Game Gamestate
--PAUSE    = require "gamestate.pause",    --Pause Gamestate
--GAMEOVER = require "gamestate.gameover"  --Gameover Gamestate
SPLASH = require "gamestates.splash",
CREDITS = require "gamestates.credits"
}

function love.load()

    Setup.config() --Configure your game

    local callbacks = {'errhand', 'update'}
    for c in pairs(love.handlers) do
        if c ~= 'mousepressed' and c ~= 'mousereleased' and c ~= 'mousemoved' then
            table.insert(callbacks, c)
        end
    end
    -- draw, mousereleased and mousepressed are called manually
    -- mousemoved is ignored
    Gamestate.registerEvents(callbacks) --Overwrites love callbacks to call Gamestate as well
    Gamestate.switch(GS.SPLASH) --Jump to the inicial state

    SaveManager.load()

end

-----------------
--MOUSE FUNCTIONS
-----------------

function love.draw()
    ResManager.preDraw()
    Gamestate.draw()
    ResManager.postDraw()
end

function love.mousereleased(x, y, ...)
    x, y = love.mouse.getPosition() -- fixed
    Gamestate.mousereleased(x, y, ...)
end

function love.mousepressed(x, y, but, ...)
    x, y = love.mouse.getPosition() -- fixed
    Gamestate.mousepressed(x, y, but, ...)

    if but == 1 then  --Left mouse button
        But.checkCollision(x,y)
    end
end

function love.mousemoved(x, y, dx, dy, ...)
    x, y = love.mouse.getPosition() -- fixed
    dx, dy = dx * ResManager.scale(), dy * ResManager.scale()
    Gamestate.mousemoved(x, y, dx, dy, ...)
end

function love.resize(w, h)
    ResManager.adjustWindow(w, h)
end

function love.quit()
    SaveManager.save()
end
