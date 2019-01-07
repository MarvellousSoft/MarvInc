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
    local str = "Could not upload workshop puzzle."
    if err then
        str = string.format("%s\nError: %s", str, tostring(err))
    end
    PopManager.new(
        "Error",
        str,
        Color.red(),
        {func = function() end, text = "Ok", clr = Color.black()}
    )
end

local function submitUpdate(info, id)
    local handle = Steam.UGC.startItemUpdate(Steam.utils.getAppID(), Steam.extra.parseUint64(info.id))
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
    -- show progress using getItemUpdateProgress
    local rev = {
        PreparingConfig = 0,
        PreparingContent = 1,
        UploadingContent = 2,
        UploadingPreviewFile = 3,
        CommittingChanges = 4,
        Invalid = 5, -- also Invalid when the job is finished
    }
    PopManager.newProgress(
        "Uploading to Steam Workshop",
        Color.black(),
        function()
            local st, uploaded, total = Steam.UGC.getItemUpdateProgress(handle)
            local p = rev[st] / 5
            -- total may be 0 depending on the status
            if total ~= 0 then
                p = p + 0.2 * (uploaded / total)
            end
            return p
        end
    )
    -- Actually submit
    Steam.UGC.submitItemUpdate(handle, nil, function(data, err)
        if err or data.result ~= 1 then
            if not err then print(data.result) end
            fail("Could not upload changes.")
        else
            PopManager.quit()
            PopManager.new(
                "Success",
                "Level successfully uploaded to Steam Workshop!",
                Color.green(),
                {func = function() end, text = "Ok", clr = Color.black()}
            )
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