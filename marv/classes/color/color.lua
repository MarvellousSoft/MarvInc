--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Rgb = require "classes.color.rgb"
local Hsl = require "classes.color.hsl"
--COLOR CLASS--

--Wrapper to properly handle HSV or RGB colors

local Color = {}

--Create a new color with values (a,b,c).
--A color can also be sent, and it will be copied to the new color.
--"mode" can be "hsl" (default) or "rgb"
--'stdv" is used for converting HSL from (degrees, percent, percent) to (0-255) value
function Color.new(a, b, c, d, mode, stdv)
    if type(a) == "table" then
        if a.type == "RGB" then
            return RGB(a.r, a.g, a.b, a.a)
        else
            if stdv then return  HSL(Hsl.stdv(a.h, a.s, a.l, a.a)) end
            return HSL(a.h, a.s, a.l, a.a)
        end
    end

    mode = mode or "hsl"

    if mode == "hsl" then
        if stdv then return HSL(Hsl.stdv(a,b,c,d)) end
        return HSL(a,b,c,d)
    else
        return RGB(a,b,c,d)
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

--Faeces brown
function Color.brown(mode)
    if not mode or mode == "HSL" then
        return Hsl.brown()
    else
        return Rgb.brown()
    end
end

--Granny gray
function Color.gray(mode)
    if not mode or mode == "HSL" then
        return Hsl.gray()
    else
        return Rgb.gray()
    end
end

--Coral teal
function Color.teal(mode)
    if not mode or mode == "HSL" then
        return Hsl.teal()
    else
        return Rgb.teal()
    end
end

--Marge's Magenta
function Color.magenta(mode)
    if not mode or mode == "HSL" then
        return Hsl.magenta()
    else
        return Rgb.magenta()
    end
end

--Viola's Violet
function Color.violet(mode)
    if not mode or mode == "HSL" then
        return Hsl.violet()
    else
        return Rgb.magenta()
    end
end

function normalize_color(c) return c.type == "HSL" and RGB(Hsl.convert(c.h, c.s, c.l, c.a)) or c end

--Returns the addition of three colors in RGB
function Color.add3(a, b, c)
    local na, nb, nc = normalize_color(a), normalize_color(b), normalize_color(c)
    return RGB((na.r+nb.r+nc.r)/3, (na.g+nb.g+nc.g)/3, (na.b+nb.b+nc.b)/3)
end

--Returns a random skin color. Disclaimer: not all skin colors are considered. Use at own risk.
function Color.rand_skin(mode)
    local c = Hsl.rand_skin()
    if not mode or mode == "HSL" then
        return c
    else
        return Hsl.convert(c)
    end
end

--Return functions
return Color
