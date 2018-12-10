--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    DrawTable(DRAW_TABLE.BG)

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L1)

    DrawTable(DRAW_TABLE.L1u)

    DrawTable(DRAW_TABLE.L2)

    DrawTable(DRAW_TABLE.L2u)

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI)

end

--Draw all the elements in a table
function DrawTable(t)

    for o in pairs(t) do
        if not o.invisible then
          love.graphics.setShader(o.shader) --Set object shader, if any
          o:draw() --Call the object respective draw function
          love.graphics.setShader() --Remove shader, if any
        end
    end

end

--Return functions
return draw
