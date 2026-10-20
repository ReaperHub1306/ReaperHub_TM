local Lighting = game:GetService("Lighting")

-- Nếu đã bật rồi -> Bấm lại sẽ TẮT (Restore lại ánh sáng ban đầu)
if _G.FullbrightEnabled then
    _G.FullbrightEnabled = false
    
    if _G.FullbrightConnection then
        _G.FullbrightConnection:Disconnect()
        _G.FullbrightConnection = nil
    end
    
    -- Trả lại thông số ánh sáng cũ
    if _G.OldLightingSettings then
        Lighting.Brightness = _G.OldLightingSettings.Brightness
        Lighting.ClockTime = _G.OldLightingSettings.ClockTime
        Lighting.FogEnd = _G.OldLightingSettings.FogEnd
        Lighting.GlobalShadows = _G.OldLightingSettings.GlobalShadows
        Lighting.Ambient = _G.OldLightingSettings.Ambient
        Lighting.OutdoorAmbient = _G.OldLightingSettings.OutdoorAmbient
    end
    return
end

-- Đánh dấu đã bật & Lưu lại cấu hình ánh sáng cũ của game
_G.FullbrightEnabled = true
_G.OldLightingSettings = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

-- Hàm ép ánh sáng cực đại
local function applyFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

applyFullbright()

-- Lắng nghe nếu game tự thay đổi thời gian/ánh sáng thì ép lại
_G.FullbrightConnection = Lighting.Changed:Connect(function()
    if _G.FullbrightEnabled then
        applyFullbright()
    end
end)
