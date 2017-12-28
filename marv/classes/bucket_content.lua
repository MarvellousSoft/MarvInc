--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"

local function default_init(self, args)
    self.img = args and args.img and OBJS_IMG[args.img]
    self.color = args and args.color
end

local empty, water, paint

empty = Class {
    img = OBJS_IMG.bucket_content,
    color = Color.new(0, 0, 140),
    init = default_init
}

function empty:pickup_other(bot, grid, i, j)
    local o = grid[i][j]
    if o.tp ~= 'container' then return "Not enough free hands" end
    assert(o.content == 'paint') -- no other case for now
    bot.inv.content = paint()
    bot.inv.content.color = o.content_color
end

function empty:drop(bot, grid, i, j, blocked)
    if grid[i][j] and grid[i][j].onInventoryDrop then
        grid[i][j]:onInventoryDrop(bot)
        bot.inv = nil
        return
    end
    local _o = grid[i][j]
    if _o and (_o.key == 'lava' or _o.key == 'fireplace') then
        -- dropping into lava
        -- TODO maybe play some burning sfx
    elseif blocked or (_o and not _o.is_ephemeral) then
        return "Dropping obstructed"
    else
        ROOM:put(bot.inv, i, j)
        if _o then -- refresh lasers
            ROOM:deleteEphemeral()
            ROOM:createEphemeral()
        end
    end
    bot.inv = nil
end

water = Class {
    img = OBJS_IMG.bucket_content,
    color = Color.blue(),
    init = default_init
}

function water:drop(bot, grid, i, j, blocked)
    if blocked then return "Dropping obstructed" end
    local _o = grid[i][j]
    if _o and _o.bucketable then
        _o:sleep()
    elseif not _o then
        ROOM:put(bot.inv, i, j)
    else
        return "Dropping obstructed"
    end
    bot.inv = nil
end

paint = Class {
    img = OBJS_IMG.bucket_content,
    color = Color.new(0, 0, 30),
    max_uses = 1
}

function paint:init(args)
    default_init(self, args)
    -- how many uses
    self.uses = args and args.uses or 1
end

function paint:pickup_other(bot, grid, i, j)
    local o = grid[i][j]
    if o.tp ~= 'container' then return "Not enough free hands" end
    assert(o.content == 'paint') -- no other case for now
    -- assuming the color is the same
    self.uses = math.min(self.uses + 1, self.max_uses)
end

function paint:drop(bot, grid, i, j, blocked)
    if blocked then return "Dropping obstructed" end
    local _o = grid[i][j]
    if _o then
        return "Dropping obstructed"
    else
        ROOM.color_floor[i][j] = self.color
        self.uses = self.uses - 1
        if self.uses == 0 then
            bot.inv.content = empty()
        end
    end
end

return {empty, water, paint}
