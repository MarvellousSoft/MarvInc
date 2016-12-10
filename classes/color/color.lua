local Rgb = require "classes.color.rgb"
local Hsl = require "classes.color.hsl"
--COLOR CLASS--

--Wrapper to properly handle HSV or RGB colors

local Color = {}

--Create a new color with values (a,b,c).
--A color can also be sent, and it will be copied to the new color.
--Mode can be "hsl" (default) or "rgb"
function Color.new(a, b, c, mode)
    if type(a) == "table" then
        if a.type == "RGB" then
            return RGB(a.r, a.g, a.b)
        else
            return HSL(a.h, a.s, a.l)
        end
    end

    mode = mode or "hsl"

    if mode == "hsl" then
        return HSL(a,b,c)
    else
        return RGB(a,b,c)
    end
end

--Return color values
function Color.clr(c)
    if c.type == "RGB" then
        Rgb.rgb(c)
    elseif c.type == "HSL" then
        Hsl.hsl(c)
    end
end

--Return color values + alpha
function Color.clra(c)
    if c.type == "RGB" then
        Rgb.rgba(c)
    elseif c.type == "HSL" then
        Hsl.hsla(c)
    end
end

--Return color values + alpha
function Color.a(c)
    if c.type == "RGB" then
        Rgb.a(c)
    elseif c.type == "HSL" then
        Hsl.a(c)
    end
end

--Copy colors from a color c2 to a color c1 (both have to be the same type)
function Color.copy(c1, c2)
    if c1.type == "RGB" then
        Rgb.copy(c1, c2)
    elseif c1.type == "HSL" then
        Hsl.copy(c1, c2)
    end
end

--Set color c as love drawing color
function Color.set(c)
    if c.type == "RGB" then
        Rgb.set(c)
    elseif c.type == "HSL" then
        Hsl.set(c)
    end
end

--Set the color used for drawing using 255 as alpha amount
function Color.setOpaque(c)
    if c.type == "RGB" then
        Rgb.setOpaque(c)
    elseif c.type == "HSL" then
        Hsl.setOpaque(c)
    end
end

--Set the color used for drawing using 0 as alpha amount
function Color.setOpaque(c)
    if c.type == "RGB" then
        Rgb.setTransp(c)
    elseif c.type == "HSL" then
        Hsl.setTransp(c)
    end
end

---------------
--PRESET COLORS
---------------

--Dark Black
function Color.black(mode)
    if not mode or mode == "HSL" then
            return Hsl.black()
    else
            return Rgb.black()
    end
end

--Clean white
function Color.white(mode)
    if not mode or mode == "HSL" then
        return Hsl.white()
    else
        return Rgb.white()
    end
end

--Cheerful red
function Color.red(mode)
    if not mode or mode == "HSL" then
        return Hsl.red()
    else
        return Rgb.red()
    end
end

--Calm green
function Color.green(mode)
    if not mode or mode == "HSL" then
        return Hsl.green()
    else
        return Rgb.green()
    end
end

--Smooth blue
function Color.blue(mode)
    if not mode or mode == "HSL" then
        return Hsl.blue()
    else
        return Rgb.blue()
    end
end

--Jazzy orange
function Color.orange(mode)
    if not mode or mode == "HSL" then
        return Hsl.orange()
    else
        return Rgb.orange()
    end
end

--Sunny yellow
function Color.yellow(mode)
    if not mode or mode == "HSL" then
        return Hsl.yellow()
    else
        return Rgb.yellow()
    end
end

--Sexy purple
function Color.purple(mode)
    if not mode or mode == "HSL" then
        return Hsl.purple()
    else
        return Rgb.purple()
    end
end

--Happy pink
function Color.pink(mode)
    if not mode or mode == "HSL" then
        return Hsl.pink()
    else
        return Rgb.pink()
    end
end

--Invisible transparent
function Color.transp(mode)
    if not mode or mode == "HSL" then
        return Hsl.transp()
    else
        return Rgb.transp()
    end
end

--Return functions
return Color
