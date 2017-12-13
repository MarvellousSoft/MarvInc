require "classes.primitive"
local Color = require "classes.color.color"

-- Bot class

local bot = {}

-- copies bot attributes if it didn't die
-- if nil then create a new one
bot.current_bot = nil

Bot = Class{
    __includes = {Object},
    init = function(self, grid, i, j)
        self.steps = 0

        -- i and j are 0-indexed positions in grid
        Object.init(self, grid, i, j, "bot", true)

        local head_i, body_i
        if bot.current_bot then
            local b = bot.current_bot
            -- get previous bot
            head_i, body_i = b.head_i, b.body_i
            self.head_clr = Color.new(b.head_clr, 200, 200)
            self.body_clr = Color.new(b.body_clr, 200, 200)
            self.name = b.name
            self.traits = b.traits
            self.first_time = b.first_time
        else
            -- random body
            head_i = love.math.random(#HEAD)
            self.head_clr = Color.new(love.math.random(256) - 1, 200, 200)
            body_i = love.math.random(#BODY)
            self.body_clr = Color.new(love.math.random(256) - 1, 200, 200)

            -- Get random name from list
            self.name = NAMES[love.math.random(#NAMES)]

            --Create 1-3 traits
            self.traits = {}

            --If its the first time the bot is appearing
            self.first_time = true

            -- Number of traits
            local trait_n = love.math.random(3)

            -- beginning of a knuth shuffle
            while #self.traits < trait_n do
                local i = love.math.random(#self.traits + 1, #TRAITS)
                TRAITS[i], TRAITS[#self.traits+1] = TRAITS[#self.traits+1], TRAITS[i]
                table.insert(self.traits, TRAITS[#self.traits+1][1])
            end

        end

        -- copy it to bot.current_bot
        bot.current_bot = {
            head_i = head_i,
            body_i = body_i,
            head_clr = self.head_clr.h,
            body_clr = self.body_clr.h,
            name = self.name,
            traits = self.traits,
            first_time = self.first_time
        }

        self.head = HEAD[head_i]
        self.body = BODY[body_i]

        self.sx = ROOM_CW/self.body:getWidth()
        self.sy = ROOM_CH/self.body:getHeight()

        -- Inventory
        self.inv = nil

        --Send intro message
        if self.first_time then
          local d = love.math.random(3)
          local handle = MAIN_TIMER:after(d,
            function()
              Signal.emit("new_bot_message")
            end
          )
          table.insert(self.handles, handle)
        end

    end
}

function Bot:cleanAndKill()
    Object.kill(self, ROOM.grid_obj)
    bot.current_bot = nil -- erase current bot
    Signal.emit("death")
    --SFX.fail:stop()
    --SFX.fail:play()
end

function Bot:kill(grid, obj)
    if obj and obj.tp == 'container' then
        local n = Util.findId('info_tab').dead
        StepManager.stop(nil, "You somehow let Bot #" .. n .. " fall into a paint container. That's embarassing. Another unit has been dispatched to replace #"..n..". A notification has been dispatched to HR and this incident shall be added to your personal file.")
    elseif obj and obj.tp == 'dead' and obj.key == 'lava' then
        local n = Util.findId('info_tab').dead
        if ROOM.puzzle.id == 'franz1' then
            ROOM.puzzle:manage_objectives(true)
            self:cleanAndKill()
        else
            StepManager.stop(nil, "Bot #" .. n .. " burned in hot lava. Another unit has been dispatched to replace #"..n..". A notification has been dispatched to HR and this incident shall be added to your personal file.")
        end
    else
        StepManager.stop()
    end
end

function Bot:next_block(grid, r, c, o)
    local p = o
    if not o then
        p = ORIENT[self.r[2]]
    end
    local px, py = self.pos.x + p.x, self.pos.y + p.y
    if  px < 1 or
        px > r or
        py < 1 or
        py > c then
        return nil
    end
    return grid[px][py]
end

function Bot:move(grid, r, c)
    local x, y = self.pos.x, self.pos.y
    Object.move(self, grid, r, c)
    if x ~= self.pos.x or y ~= self.pos.y then
        self.steps = self.steps + 1
    end
end

function Bot:pickup(grid, r, c)
    local p = ORIENT[self.r[2]]
    local px, py = self.pos.x + p.x, self.pos.y + p.y
    if self.inv then
        if self.inv.pickup_other then
            return self.inv:pickup_other(self, grid, px, py)
        else
            return "Not enough free hands"
        end
    end
    local o = grid[px][py]
    if o and o.pickable then
        return o:toInventory(self)
    end
end

function Bot:drop(grid, r, c)
    local p = ORIENT[self.r[2]]
    if self.inv then
        return self.inv:use(self, grid, self.pos.x + p.x, self.pos.y + p.y, self:blocked(grid, r, c))
    end
end

function Bot:blocked(grid, r, c, o, notify)
    local p = o
    if not o then
        p = ORIENT[self.r[2]]
    end
    local px, py = self.pos.x + p.x, self.pos.y + p.y
    if  px < 1 or
        px > r or
        py < 1 or
        py > c then
        return true
    end
    local _o = grid[px][py]
    if notify and _o and _o.onWalk then
        _o:onWalk(self)
    end
    return ROOM.inv_wall[px][py] or (_o and (_o.tp ~= "dead" and _o.tp ~= "dead_switch" and _o.tp ~= "container"))
end

function Bot:draw()
    local w, h = self.body:getWidth(), self.body:getHeight()
    local dw, dh = ROOM_CW / 2, ROOM_CH / 2
    Color.set(self.body_clr)
    love.graphics.draw(self.body, self.rx + dw, self.ry + dh, self.r[1],
                       self.sx, self.sy, w / 2, h / 2)
    Color.set(self.head_clr)
    love.graphics.draw(self.head, self.rx + dw, self.ry + dh, self.r[1],
                       self.sx, self.sy, w / 2, h / 2)

end

return bot
