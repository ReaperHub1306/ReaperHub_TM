local HttpService = game:GetService("HttpService")
local ConfigFile = "ReaperHub_Config.json"

_G.ReaperHubConfig = _G.ReaperHubConfig or {
    AutoSave = false,
    Language = "English"
}

-- Chức năng Toggle (Bật / Tắt Auto Save)
_G.ReaperHubConfig.AutoSave = not _G.ReaperHubConfig.AutoSave

if _G.ReaperHubConfig.AutoSave then
    local success, err = pcall(function()
        if writefile then
            writefile(ConfigFile, HttpService:JSONEncode(_G.ReaperHubConfig))
        end
    end)
    if success then
        print("[ReaperHub] Auto Save: ENABLED & Config Saved!")
    end
else
    print("[ReaperHub] Auto Save: DISABLED")
end
