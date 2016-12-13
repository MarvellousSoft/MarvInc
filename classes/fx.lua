local Color = require "classes.color.color"
local fx = {}

local full_s = false
local intro = false

function fx.full_static()
    full_s = true
    EVENTS_LOCK = true
    SFX.loud_static:play()
    fx.ang = 0
    fx.h = H
    fx.w = W
    MAIN_TIMER.after(1.2, function() MAIN_TIMER.tween(.2, fx, {h = 10}) end)
    MAIN_TIMER.after(1.4, function() MAIN_TIMER.tween(.38, fx, {w = 0}, "out-cubic") end)
    MAIN_TIMER.after(1.8, function() SFX.loud_static:stop() end)
    MAIN_TIMER.after(2.9, function()
        SFX.loud_static:stop()
        full_s = false
        Gamestate.push(GS.CREDITS)
    end)
end

function fx.intro()
    intro = true
    fx.w = 0
    fx.h = 10
    fx.alp = 255
    MAIN_TIMER.tween(.4, fx, {w = W}, "in-cubic")
    MAIN_TIMER.after(.4, function() MAIN_TIMER.tween(.3, fx, {h = H}) end)
    MAIN_TIMER.after(1.5, function() intro = false EVENTS_LOCK = false end)
    MAIN_TIMER.tween(1.5, fx, {alp = 0}, "out-quad")
end

local function stencil()
    love.graphics.ellipse("fill", W / 2, H / 2, W * .7, fx.h)
end
local function stencil2()
    love.graphics.rectangle("fill", (W - fx.w) / 2, 0, fx.w, H)
end

function fx.pre_draw()
    love.graphics.clear()
end

function fx.post_draw()
    if intro then
        Color.set(Color.new(255, 255, 255, fx.alp))
        love.graphics.rectangle("fill", 0, 0, W, H)
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.stencil(stencil2, "increment", nil, true)
        love.graphics.setStencilTest("lequal", 1)
        Color.set(Color.black())
        love.graphics.rectangle("fill", 0, 0, W, H)
        love.graphics.setStencilTest()
    end
    if full_s then
        Color.set(Color.black())
        love.graphics.rectangle("fill", 0, 0, W, H)
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.stencil(stencil2, "increment", nil, true)
        love.graphics.setStencilTest("greater", 1)
        Color.set(Color.white())
        local s = ROOM.static_img
        love.graphics.draw(s, W / 2, H / 2, fx.ang, 1.1 * W / s:getWidth(), 1.1 * W / s:getHeight(), s:getWidth() / 2, s:getHeight() / 2)
        fx.ang = fx.ang + math.pi / 2
    end
end

return fx
