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
require "classes.tabs.email"
require "classes.tabs.code"
require "classes.tabs.info"

require "classes.pc-box"
require "classes.sprite"
require "classes.spriteobject"
require "classes.object"
require "classes.obstacle"
require "classes.dead"
require "classes.bucket"
require "classes.deadswitch"
require "classes.emitter"
require "classes.bot"
require "classes.objective"
require "classes.puzzle"
require "classes.reader"
require "classes.room"
require "classes.opened_email"
StepManager = require "classes.stepmanager"
LoreManager = require "classes.lore-manager"
PopManager  = require "classes.popmanager"

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

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well
    --Gamestate.switch(GS.SPLASH) --Jump to the inicial state
    Gamestate.switch(GS.CREDITS) --Jump to the inicial state

end

-----------------
--MOUSE FUNCTIONS
-----------------

function love.mousepressed(x, y, button, istouch)

    if button == 1 then  --Left mouse button
        But.checkCollision(x,y)
    end

end
