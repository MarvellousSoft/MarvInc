--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local res = {}

W = 1366
H = 768

local scale, tx, ty

function res.init()
    love.graphics.setDefaultFilter('linear', 'linear')
    res.getRealWidth = love.graphics.getWidth
    res.getRealHeight = love.graphics.getHeight
    love.graphics.getWidth = function() return W end
    love.graphics.getHeight = function() return H end

    res.getMouseRealPosition = love.mouse.getPosition
    love.mouse.getPosition = function()
        local x, y = res.getMouseRealPosition()
        x = (x - tx) / scale
        y = (y - ty) / scale
        return x, y
    end
end

function res.toRealCoords(x, y)
    return tx + x * scale, ty + y * scale
end

function res.scale() return scale end


function res.adjustWindow(w, h)
    local sx, sy = w / W, h / H
    scale = math.min(sx, sy)
    if sx <= sy then
        tx, ty = 0, (h - H * sx) / 2
    else
        tx, ty = (w - W * sy) / 2, 0
    end
end

function res.preDraw()
    love.graphics.push()
    love.graphics.translate(tx, ty)
    love.graphics.scale(scale, scale)
end

function res.postDraw()
    love.graphics.pop()
    love.graphics.setColor(0, 25, 0)
    if tx > 0 then
        love.graphics.rectangle('fill', 0, 0, tx, res.getRealHeight())
        love.graphics.rectangle('fill', res.getRealWidth() - tx, 0, tx, res.getRealHeight())
    elseif ty > 0 then
        love.graphics.rectangle('fill', 0, 0, res.getRealWidth(), ty)
        love.graphics.rectangle('fill', 0, res.getRealHeight() - ty, res.getRealWidth(), ty)
    end
end

return res
