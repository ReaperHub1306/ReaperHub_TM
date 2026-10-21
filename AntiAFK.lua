-- ==========================================
-- REAPERHUB: ANTI-AFK MODULE
-- ==========================================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra nếu đã bật trước đó thì Toggle trạng thái
if _G.ReaperHub_AntiAFK then
    _G.ReaperHub_AntiAFK = false
    print("[ReaperHub] Anti-AFK: DISABLED")
    return
end

_G.ReaperHub_AntiAFK = true
print("[ReaperHub] Anti-AFK: ENABLED")

-- Kết nối sự kiện Idled (Chống Kick AFK)
if not _G.AntiAFKConnected then
    _G.AntiAFKConnected = true
    LocalPlayer.Idled:Connect(function()
        if _G.ReaperHub_AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            print("[ReaperHub] Anti-AFK Triggered! Kept session alive.")
        end
    end)
end
