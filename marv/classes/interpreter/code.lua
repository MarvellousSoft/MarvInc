--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Ops = require "classes.interpreter.operations"
local Color = require "classes.color.color"

Code = Class{
    init = function(self, ops, labs, real_line)
        self.ops = ops
        self.labs = labs
        self.real_line = real_line
        self.cur = 1
    end,
    type = 'code'
}

function Code:start()
    local ct = Util.findId("code_tab")
    ct:showLine(1)
    ct.lock = ct.lock + 1
    ct.memory:reset()
end

function Code:step()
    Util.findId("code_tab"):showLine(self.real_line[self.cur])
    if self.cur <= #self.ops then
        local lab, err = self.ops[self.cur]:execute()
        if lab then
            local line = self.real_line[self.cur]
            self.cur = self.labs[lab]
            if not self.cur then
                StepManager.stop("Code error!",
                "Your code got a runtime error (0x" .. love.math.random(10000, 99999) .. ") on line " .. line ..  ". Error message:\n\n\"" .. (err or lab) .. "\"\n\nFor this reason, subject #" .. Util.findId("info_tab").dead .. " \"" .. ROOM.bot.name .. "\" is no longer working and will be sacrificed and replaced.")
                return 'error'
            end
        else
            self.cur = self.cur + 1
        end
    end
    if self.cur > #self.ops then return 'halt' end
end

function Code:stop(show_code_state)
    local ct = Util.findId("code_tab")
    if not show_code_state then
        ct:showLine(nil)
    end
    ct.lock = ct.lock + 1
end
