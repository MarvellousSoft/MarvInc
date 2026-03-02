local LParser = require "lparser.parser"
local inifile = require "extra_libs.inifile"

local workshop = {}

function workshop.getAllDownloadedPuzzles(surface_errors)
    local all = {}
    local _, items = Steam.UGC.GetSubscribedItems(Steam.UGC.GetNumSubscribedItems(false), false)
    for _, id in ipairs(items) do
        if bit.band(Steam.UGC.GetItemState(id), Steam.k_EItemStateInstalled) ~= 0 then
            local P = LParser.parse(tostring(id), true, 1, surface_errors)
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
    local handle = Steam.UGC.StartItemUpdate(Steam.Utils.GetAppID(), Steam.Extra.ParseUint64(info.id))
    local path = love.filesystem.getSaveDirectory() .. "/custom/" .. id .. "/"
    if info.title then
        assert(Steam.UGC.SetItemTitle(handle, info.title))
    end
    if info.description then
        assert(Steam.UGC.SetItemDescription(handle, info.description:gsub("\\n", "\n")))
    end
    if info.preview then
        assert(Steam.UGC.SetItemPreview(handle, path .. info.preview))
    end
    assert(Steam.UGC.SetItemContent(handle, path))
    -- show progress using GetItemUpdateProgress
    local status_progress = {
        [Steam.k_EItemUpdateStatusPreparingConfig] = 0,
        [Steam.k_EItemUpdateStatusPreparingContent] = 1,
        [Steam.k_EItemUpdateStatusUploadingContent] = 2,
        [Steam.k_EItemUpdateStatusUploadingPreviewFile] = 3,
        [Steam.k_EItemUpdateStatusCommittingChanges] = 4,
        [Steam.k_EItemUpdateStatusInvalid] = 5, -- also Invalid when the job is finished
    }
    PopManager.newProgress(
        "Uploading to Steam Workshop",
        Color.black(),
        function()
            local st, uploaded, total = Steam.UGC.GetItemUpdateProgress(handle)
            local p = (status_progress[st] or 0) / 5
            -- total may be 0 depending on the status
            if total ~= 0 then
                p = p + 0.2 * (uploaded / total)
            end
            return p
        end
    )
    -- Actually submit
    Steam.UGC.SubmitItemUpdate(handle, "", function(data, err)
        if err or data.m_eResult ~= 1 then
            fail("Could not upload changes.")
        else
            PopManager.quit()
            PopManager.new(
                "Success",
                "Level successfully uploaded to Steam Workshop!",
                Color.green(),
                {func = function() end, text = "Ok", clr = Color.black()}
            )
            Steam.Friends.ActivateGameOverlayToWebPage("steam://url/CommunityFilePage/" .. info.id, Steam.k_EActivateGameOverlayToWebPageMode_Default)
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
        Steam.UGC.CreateItem(Steam.Utils.GetAppID(), Steam.k_EWorkshopFileTypeCommunity, function(data, err)
            if err or data.m_eResult ~= 1 then
                fail("Could not create item.")
            else
                t.info.id = tostring(data.m_nPublishedFileId)
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
