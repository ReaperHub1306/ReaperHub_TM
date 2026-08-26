-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

------------------------------------------------------------------------
-- CƠ CHẾ BẬT / TẮT (TOGGLE) & DỌN DẸP BỘ NHỚ
------------------------------------------------------------------------
if _G.EspBossEnabled then
    _G.EspBossEnabled = false
    
    -- Xóa toàn bộ ESP Boss đang có trên màn hình
    local BossFolder = Workspace:FindFirstChild("boss's")
    if BossFolder then
        for _, boss in ipairs(BossFolder:GetChildren()) do
            if boss:FindFirstChild("BossESP_GUI") then
                boss.BossESP_GUI:Destroy()
            end
            if boss:FindFirstChild("BossHighlight") then
                boss.BossHighlight:Destroy()
            end
        end
    end
    
    -- Ngắt kết nối sự kiện thêm boss mới
    if _G.BossAddedConnection then
        _G.BossAddedConnection:Disconnect()
        _G.BossAddedConnection = nil
    end
    return
end

_G.EspBossEnabled = true

------------------------------------------------------------------------
-- CẤU HÌNH ESP BOSS
------------------------------------------------------------------------
local BossFolder = Workspace:WaitForChild("boss's", 10)

local function createBossESP(boss)
    if not boss or not _G.EspBossEnabled or boss:FindFirstChild("BossESP_GUI") then return end

    local targetPart = boss:WaitForChild("HumanoidRootPart", 2) 
        or boss:FindFirstChild("Head") 
        or boss:FindFirstChildWhichIsA("BasePart")

    if not targetPart then return end

    -- Highlight Boss xuyên tường cực rõ
    local highlight = Instance.new("Highlight")
    highlight.Name = "BossHighlight"
    highlight.Adornee = boss
    highlight.FillColor = Color3.fromRGB(255, 30, 30)
    highlight.FillTransparency = 0.25
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = boss

    -- BillboardGui hiển thị thông tin Boss
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BossESP_GUI"
    billboard.Adornee = targetPart
    billboard.Size = UDim2.new(0, 220, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 4000
    billboard.Parent = boss

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 15
    textLabel.Parent = billboard

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = textLabel

    local bossName = boss.Name

    -- Vòng lặp cập nhật khoảng cách
    task.spawn(function()
        while _G.EspBossEnabled and boss and boss.Parent and targetPart and targetPart.Parent do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = math.floor((root.Position - targetPart.Position).Magnitude)
                textLabel.Text = string.format("☠️ [BOSS] %s ☠️\n[%dm]", bossName, dist)
            else
                textLabel.Text = "☠️ [BOSS] " .. bossName .. " ☠️"
            end
            task.wait(0.1)
        end
    end)
end

-- Khởi chạy ESP cho các boss hiện có
if BossFolder then
    for _, child in ipairs(BossFolder:GetChildren()) do
        createBossESP(child)
    end
    
    -- Tự động nhận diện boss mới xuất hiện
    _G.BossAddedConnection = BossFolder.ChildAdded:Connect(function(child)
        task.wait(0.1)
        createBossESP(child)
    end)
end
