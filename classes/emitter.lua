require "classes.primitive"
local Color = require "classes.color.color"

-- Emitter class

Emitter = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, color, _, __, args)
        Object.init(self, grid, i, j, "emitter", bg)
        self.color = Color[color or "white"](Color)

        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        self.traps = {}
        -- (x1, y1) -> (x2, y2)
        -- Lines must always be horizontal or vertical
        if args.x1 == args.x2 then
            -- Vertical
            local _max_y, _min_y

            if args.y1 > args.y2 then _max_y, _min_y = args.y1,  args.y2
            else _max_y, _min_y = args.y2, args.y1 end

            if _max_y < j then
                self.r = NORTH_R
            elseif _min_y > j then
                self.r = SOUTH_R
            end

            local _dy = _max_y - _min_y + 1
            for k=1, _dy do
                table.insert(self.traps, DeadSwitch(grid, args.x1, _min_y+(k-1),
                    unpack(args.t_args)))
                self.traps[k].r = self.r
            end
        elseif args.y1 == args.y2 then
            -- Horizontal
            local _max_x, _min_x

            if args.x1 > args.x2 then _max_x, _min_x = args.x1,  args.x2
            else _max_x, _min_x = args.x2, args.x1 end

            if _max_x < i then
                self.r = WEST_R
            elseif _min_x > i then
                self.r = EAST_R
            end

            local _dx = _max_x - _min_x + 1
            for k=1, _dx do
                table.insert(self.traps, DeadSwitch(grid, _min_x+(k-1), args.y1,
                    unpack(args.t_args)))
                self.traps[k].r = self.r
            end
        else print("ERROR! Emitter lines cannot be complex!") end
        self.awake = true
    end
}

function Emitter:toggle()
    if self.awake then self:sleep() else self:wakeup() end
end

function Emitter:sleep()
    for _, v in ipairs(self.traps) do
        ROOM:sedate(v)
    end
    self.awake = false
end

function Emitter:wakeup()
    for _, v in ipairs(self.traps) do
        ROOM:wakeup(v)
    end
    self.awake = true
end
