local Lighting = game:GetService("Lighting")

-- Nếu đã bật rồi -> Bấm lại sẽ TẮT (Khôi phục Sương mù)
if _G.RemoveFogEnabled then
    _G.RemoveFogEnabled = false
    
    if _G.FogConnection then
        _G.FogConnection:Disconnect()
        _G.FogConnection = nil
    end
    
    -- Khôi phục tầm nhìn sương mù cũ
    if _G.OldFogEnd then
        Lighting.FogEnd = _G.OldFogEnd
    end
    
    -- Bật lại Atmosphere nếu có
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") and _G.DisabledAtmospheres and _G.DisabledAtmospheres[v] then
            v.Parent = Lighting
        end
    end
    _G.DisabledAtmospheres = nil
    return
end

-- BẬT: Lưu lại tầm nhìn sương mù ban đầu
_G.RemoveFogEnabled = true
_G.OldFogEnd = Lighting.FogEnd
_G.DisabledAtmospheres = {}

local function disableFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = 1e10 --Đẩy sương mù ra cực xa
    
    -- Ẩn các effect Atmosphere làm mờ màn hình
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") then
            _G.DisabledAtmospheres[v] = true
            v.Parent = nil -- Tạm thời gỡ khỏi Lighting
        end
    end
end

disableFog()

-- Liên tục chặn nếu game cố tình spawn sương mù mới
_G.FogConnection = Lighting.ChildAdded:Connect(function(child)
    if _G.RemoveFogEnabled and child:IsA("Atmosphere") then
        task.wait()
        _G.DisabledAtmospheres[child] = true
        child.Parent = nil
    end
end)
