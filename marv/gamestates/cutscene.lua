--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local state = {}

local i, j = 0, 0
local step
local w, h

local quad, batch

local window, thump = nil, nil

local close_door, car_passing, ambient

local timer

function state:enter(prev, _img, _w, _h, total)
    GS['GAME'].getBGMManager():stopBGM()
    timer = Timer.new()
    if _img == 'assets/cutscenes/body_drop.png' then
        thump = love.audio.newSource('assets/sound/thump.wav', 'static')
        window = love.audio.newSource('assets/sound/window.ogg', 'static')
        window:play()
    end
    n_w, n_h = _w, _h
    step = total / (n_w * n_h)
    img = love.graphics.newImage(_img)
    w, h = img:getWidth() / n_w, img:getHeight() / n_h
    quad = love.graphics.newQuad(0, 0, w, h, img:getWidth(), img:getHeight())
    batch = love.graphics.newSpriteBatch(img, 180)
    batch:add(quad, 0, 0)

    close_door = love.audio.newSource('assets/sound/car_close_door.wav', 'static')
    self.close_door_vol = 1
    car_passing = love.audio.newSource('assets/sound/car_passing.wav', 'static')
    ambient = love.audio.newSource('assets/sound/ambient.mp3', 'stream')
    ambient:play()
    self.sound_all = 1
    self.fade_out = 0
end

local vol, vol_dec = 1, 0
local cur = 0
function state:update(dt)
    timer:update(dt)
    vol = vol - vol_dec * dt
    if vol < 0 then vol = 0 end
    if car_passing then
        car_passing:setVolume(vol * self.sound_all)
        close_door:setVolume(self.close_door_vol * self.sound_all)
        ambient:setVolume(self.sound_all)
    end
    cur = cur + dt
    if cur > step and j < n_h then
        cur = 0
        i = i + 1
        if i == 10 and j == 10 then
            close_door:play()
        end
        if i == 3 and j == 2 and thump then
            thump:play()
        end
        if i == n_w then
            i = 0
            j = j + 1
            if j == 5 then
                car_passing:play()
            end
            if j == 7 then
                vol_dec = 1/4
            end
            if j == n_h then
                timer:after(2.5, function() timer:tween(2.5, self, {close_door_vol = 0}) end)
                timer:after(4, function() timer:tween(1, self, {sound_all = 0, fade_out = 255}) end)
                timer:after(5, Gamestate.pop)
                return
            end
        end
        quad:setViewport(i * w, j * h, w, h)
        batch:clear()
        batch:add(quad, 0, 0)
    end
end

local white = Color.white()
local black = Color.black()
function state:draw()
    Color.set(white)
    love.graphics.draw(batch, 0, 0, 0, W / w, H / h)
    black.a = self.fade_out
    Color.set(black)
    love.graphics.rectangle('fill', 0, 0, W, H)
end

function state:leave()
    if window then
        window:stop()
        thump:stop()
        window, thump = nil, nil
    end
    close_door:stop()
    car_passing:stop()
    ambient:stop()
    close_door, car_passing, ambient = nil, nil, nil
    Gamestate.push(GS.NEWS, 'against', 4, 1)
end

return state
