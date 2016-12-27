local Color = require "classes.color.color"
local StepManager = require "classes.stepmanager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"
local FX = require "classes.fx"

local lore = {}

-- Timer used for everything related to lore
local timer = Timer.new()
lore.timer = timer
-- Events triggered by completing puzzles
local events = {}
local old_events = {}
-- Puzzles already completed
lore.puzzle_done = {}
-- Emails sent that are puzzles -- Edited by the lore events
lore.email = {}

-- Automatically adds all .lua's in classes/lore_events
function lore.init()
    local evts = love.filesystem.getDirectoryItems("classes/lore_events")
    for _, file in ipairs(evts) do
        if #file > 4 and file:sub(-4) == '.lua' then
            file = file:sub(1, -5)
            events[require("classes.lore_events." .. file)] = true
        end
    end
    lore.check_all() -- events without requisites
end

-- Check for events that may trigger now
function lore.check_all()
    if not events then return end
    for evt in pairs(events) do
        local all_done = true
        for _, puzzle in ipairs(evt.require_puzzles) do
            if not lore.puzzle_done[puzzle] then
                all_done = false
                break
            end
        end
        if all_done then
            events[evt] = nil
            old_events[evt] = true
            timer:after(evt.wait or 0, evt.run)
        end
    end
end

-- Marks that a puzzle was completed
function lore.mark_completed(puzzle)
    StepManager.pause()
    if lore.puzzle_done[puzzle.id] then
        puzzle.already_completed()
    else
        lore.puzzle_done[puzzle.id] = true
        puzzle.first_completed()
        if lore.email[puzzle.id] then
            lore.email[puzzle.id].is_completed = true
        end

        lore.check_all()
    end
end

-- Message to show when a puzzle was already completed before
function lore.already_completed()
    PopManager.new("Puzzle completed (again)",
        "You did what you had already done, and possibly killed some more test subjects.\n\nGreat.",
        Color.yellow(), {
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

return lore
