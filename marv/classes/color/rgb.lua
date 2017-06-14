--MODULE FOR COLOR AND STUFF--

local rgb = {}

--Color object
RGB = Class{
    init = function(self, r, g, b, a)
        self.type = "RGB"
        self.r     = r or 255 --Red
        self.g     = g or 255 --Green
        self.b     = b or 255 --Blue
        self.a     = a or 255 --Alpha
    end
}

------------------
--USEFUL FUNCTIONS
------------------

--Return red, green and blue levels of given color c
function rgb.rgb(c) return c.r, c.g, c.b end

--Return red, green, blue and alpha levels of given color c
function rgb.rgba(c) return c.r, c.g, c.b, c.a end

--Return alpha level of given color c
function rgb.a(c) return c.a end

--Copy colors from a color c2 to a color c1
function rgb.copy(c1, c2)  c1.r, c1.g, c1.b, c1.a = c2.r, c2.g, c2.b, c2.a end

--Set the color used for drawing
function rgb.set(c) love.graphics.setColor(c.r, c.g, c.b, c.a) end

--Set the color used for drawing using 255 as alpha amount
function rgb.setOpaque(c) love.graphics.setColor(c.r, c.g, c.b, 255) end

--Set the color used for drawing using 0 as alpha amount
function rgb.setTransp(c) love.graphics.setColor(c.r, c.g, c.b, 0) end

---------------
--PRESET COLORS
---------------

--Dark Black
function rgb.black()
  return RGB(0,0,0)
end

--Clean white
function rgb.white()
  return RGB(255,255,255)
end

--Cheerful red
function rgb.red()
  return RGB(240,41,74)
end

--Calm green
function rgb.green()
  return RGB(99,247,92)
end

--Smooth blue
function rgb.blue()
  return RGB(25,96,209)
end

--Jazzy orange
function rgb.orange()
  return RGB(247,154,92)
end

--Sunny yellow
function rgb.yellow()
  return RGB(240,225,65)
end

--Sexy purple
function rgb.purple()
  return RGB(142,62,240)
end

--Happy pink
function rgb.pink()
  return RGB(242,85,195)
end

--Invisible transparent
function rgb.transp()
  return RGB(0,0,0,0)
end

--Return functions
return rgb
