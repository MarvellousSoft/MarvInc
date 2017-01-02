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

            -- Number of traits
            local trait_n = love.math.random(3)

            -- beginning of a knuth shuffle
            while #self.traits < trait_n do
                local i = love.math.random(#self.traits + 1, #TRAITS)
                TRAITS[i], TRAITS[#self.traits] = TRAITS[#self.traits], TRAITS[i]
                table.insert(self.traits, TRAITS[#self.traits])
            end
        end

        -- copy it to bot.current_bot
        bot.current_bot = {
            head_i = head_i,
            body_i = body_i,
            head_clr = self.head_clr.h,
            body_clr = self.body_clr.h,
            name = self.name,
            traits = self.traits
        }

        self.head = HEAD[head_i]
        self.body = BODY[body_i]

        self.sx = ROOM_CW/self.body:getWidth()
        self.sy = ROOM_CH/self.body:getHeight()

        -- Inventory
        self.inv = nil
    end
}

function Bot:cleanAndKill()
    Object.kill(self, ROOM.grid_obj)
    bot.current_bot = nil -- erase current bot
    Signal.emit("death")
    --SFX.fail:stop()
    --SFX.fail:play()
end

function Bot:kill(grid)
    StepManager.stop()
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
    local _o = grid[px][py]
    if _o and _o.pickable then
        self.inv = _o
        grid[px][py] = nil
    end
end

function Bot:drop(grid, r, c)
    local p = ORIENT[self.r[2]]
    if self.inv then
        self.inv:use(self, grid, self.pos.x + p.x, self.pos.y + p.y)
    end
end

function Bot:blocked(grid, r, c, o)
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
    return _o and (_o.tp ~= "dead" and _o.tp ~= "dead_switch")
end

function Bot:draw()
    Color.set(self.body_clr)
    love.graphics.draw(self.body, self.rx + ROOM_CW/2, self.ry + ROOM_CH/2, self.r[1],
        self.sx, self.sy, ROOM_CW, ROOM_CH)
    Color.set(self.head_clr)
    love.graphics.draw(self.head, self.rx + ROOM_CW/2, self.ry + ROOM_CH/2, self.r[1],
        self.sx, self.sy, ROOM_CW, ROOM_CH)
end

return bot
