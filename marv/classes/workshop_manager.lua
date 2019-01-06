local LParser = require "lparser.parser"
local inifile = require "extra_libs.inifile"

local workshop = {}

function workshop.getAllDownloadedPuzzles()
    local all = {}
    for _, id in ipairs(Steam.UGC.getSubscribedItems()) do
        if Steam.UGC.getItemState(id).installed then
            local P = LParser.parse(tostring(id), true)
            if P ~= nil then
                table.insert(all, P)
            end
        end
    end
    return all
end

local function fail(err)
    print("Could not upload puzzle.")
    if err then
        io.write("Error: ", err, "\n")
    end
    -- some popup?
end

local function submitUpdate(info, id)
    local handle = Steam.UGC.startItemUpdate(Steam.utils.getAppID(), Steam.extra.uint64FromString(info.id))
    local path = love.filesystem.getSaveDirectory() .. "/custom/" .. id .. "/"
    if info.title then
        assert(Steam.UGC.setItemTitle(handle, info.title))
    end
    if info.description then
        assert(Steam.UGC.setItemDescription(handle, info.description:gsub("\\n", "\n")))
    end
    if info.preview then
        assert(Steam.UGC.setItemPreview(handle, path .. info.preview))
    end
    assert(Steam.UGC.setItemContent(handle, path))
    -- show progress using getItemUpdateProgress (missing in luateam)
    Steam.UGC.submitItemUpdate(handle, nil, function(data, err)
        if err or data.result ~= 1 then
            if not err then print(data.result) end
            fail("Could not upload changes.")
        else
            print("Upload successful!")
            Steam.friends.activateGameOverlayToWebPage("steam://url/CommunityFilePage/" .. info.id)
        end
    end)
end

local function uploadPuzzle(id)
    -- should check email too
    assert(LParser.parse(id), "Invalid level.")
    local ok, t = pcall(inifile.parse, "custom/" .. id .. "/workshop.ini")
    assert(ok, "Invalid workshop.ini.")
    assert(t.info) -- everything is in section [info]
    if not t.info.id then
        assert(t.info.title, "New item must have title.")
        assert(t.info.description, "New item must have description.")
        Steam.UGC.createItem(Steam.utils.getAppID(), "Community", function(data, err)
            if err or data.result ~= 1 then
                fail("Could not create item.")
            else
                t.info.id = tostring(data.publishedFileId)
                if not pcall(inifile.save, "custom/" .. id .. "/workshop.ini", t) then
                    fail("Could not save .ini")
                    -- should probably delete the item, but let's ignore it now.
                else
                    local ok, err = pcall(submitUpdate, t.info, id)
                    if not ok then fail(err) end
                end
            end
        end)
    else
        submitUpdate(t.info, id)
    end
end

function workshop.uploadPuzzle(id)
    local ok, err = pcall(uploadPuzzle, id)
    if not ok then
        fail(err)
    end
end


return workshop