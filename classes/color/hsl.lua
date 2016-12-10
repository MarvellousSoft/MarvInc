--MODULE FOR COLOR AND STUFF--

local hsl = {}

--Color object
HSL = Class{
    init = function(self, h, s, l, a)
        self.type = "HSL"
        self.h     = h or 255 --Hue
        self.s     = s or 255 --Saturation
        self.l     = l or 255 --Lightness
        self.a     = a or 255 --Alpha
    end
}

------------------
--USEFUL FUNCTIONS
------------------

--Converts HSL to RGB. (input and output range: 0 - 255)
function hsl.convert(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

--Converts HSL in (degrees, percent, percent) to (0-255) value
function hsl.stdv(h,s,l,a)
  local sh, ss, sl

  sh = h*255/360
  ss = s*255/100
  sl = l*255/100
  a = a or 255

  return sh, ss, sl, a
end

--Return hue, saturation and lightness levels of given color c
function hsl.hsl(c) return c.h, c.s, c.l end

--Return hue, saturation, lightness and alpha levels of given color c
function hsl.hsla(c) return c.h, c.s, c.l, c.a end

--Return alpha level of given color c
function hsl.a(c) return c.a end

--Copy colors from a color c2 to a color c1
function hsl.copy(c1, c2)  c1.h, c1.s, c1.l, c1.a = c2.h, c2.s, c2.l, c2.a end

--Set the color used for drawing
function hsl.set(c) love.graphics.setColor(hsl.convert(c.h, c.s, c.l, c.a)) end

--Set the color used for drawing using 255 as alpha amount
function hsl.setOpaque(c) love.graphics.setColor(hsl.convert(c.h, c.s, c.l, 255)) end

--Set the color used for drawing using 0 as alpha amount
function hsl.setTransp(c) love.graphics.setColor(hsl.convert(c.h, c.s, c.l, 0)) end

---------------
--PRESET COLORS
---------------

--Dark Black
function hsl.black()
  return HSL(hsl.stdv(0,0,0))
end

--Clean white
function hsl.white()
  return HSL(hsl.stdv(0,0,100))
end

--Cheerful red
function hsl.red()
  return HSL(hsl.stdv(351,95.4,57.1))
end

--Calm green
function hsl.green()
  return HSL(hsl.stdv(117,90.6,66.5))
end

--Smooth blue
function hsl.blue()
  return HSL(hsl.stdv(217,78.6,45.9))
end

--Jazzy orange
function hsl.orange()
  return HSL(hsl.stdv(24,90.6,66.5))
end

--Sunny yellow
function hsl.yellow()
  return HSL(hsl.stdv(55,85.4,59.8))
end

--Sexy purple
function hsl.purple()
  return HSL(hsl.stdv(267,85.6,59.2))
end

--Happy pink
function hsl.pink()
  return HSL(hsl.stdv(318,85.8,64.1))
end

--Invisible transparent
function hsl.transp()
  return HSL(0,0,0,0)
end

--Return functions
return hsl
