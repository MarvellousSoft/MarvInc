--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"
local FX = require "classes.fx"

--[[ LoreManager
Used to handle all lore events.
Lore events are events that are triggered by completing puzzles. Checkout lore_events/README.md for more info.
]]

local lore = {}

-- Timer used for everything related to lore
local timer = Timer.new()
lore.timer = timer
-- Events triggered by completing puzzles
local events = {}
lore.done_events = {} -- list of finished events
-- Puzzles already completed
lore.puzzle_done = {}

-- Automatically adds all .lua's in classes/lore_events
function lore.init()
    local evts = love.filesystem.getDirectoryItems("lore_events")
    for _, file in ipairs(evts) do
        if #file > 4 and file:sub(-4) == '.lua' then
            file = file:sub(1, -5)
            events[file] = require("lore_events." .. file)
        end
    end
end

-- Used to remove events already done by the user (in a previous game)
function lore.set_done_events(done_events)
    lore.done_events = done_events
    for _, id in ipairs(done_events) do
        events[id] = nil
    end
end

local function checkTable(tab)
    local count_done = 0
    for _, puzzle in ipairs(tab) do
        if lore.puzzle_done[puzzle] then
            count_done = count_done + 1
        end
    end
    local at_least = tab.at_least or #tab
    return count_done >= at_least
end

-- Check for events that may trigger now
function lore.check_all()
    if not events then return end
    for id, evt in pairs(events) do
        local tab = evt.require_puzzles
        local ok = true
        if type(tab[1]) == 'table' then
            for _, t in ipairs(tab) do
                ok = ok and checkTable(t)
            end
        else ok = checkTable(tab) end
        if ok then
            events[id] = nil
            table.insert(lore.done_events, id)
            timer:after(evt.wait or 0, evt.run)
        end
    end
end

-- Marks that a puzzle was completed
function lore.mark_completed(puzzle)
    if lore.puzzle_done[puzzle.id] then
        puzzle.already_completed()
        lore.check_all()
    else
        lore.puzzle_done[puzzle.id] = true
        puzzle.first_completed()
        lore.check_all()
    end
end

-- Message to show when a puzzle was already completed before
function lore.already_completed()
    PopManager.new("Puzzle completed (again)",
        "You did what you had already done, and possibly killed some more test subjects.\n\nGreat.",
        Color.purple(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "Go back",
            clr = Color.black()
        })
end

-- Default level completed action
function lore.default_completed()
    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })
end

function lore.update(dt)
    timer:update(dt)
end

--returns the total number of puzzles done
function lore.totalPuzzlesDone()
    local count = 0
    local pzl = love.filesystem.getDirectoryItems("puzzles")
    for _, file in ipairs(pzl) do
        if #file > 4 and file:sub(-4) == '.lua' then
            file = file:sub(1, -5)
            if lore.puzzle_done[file] then
                count = count + 1
            end
        end
    end
    return count
end

return lore
