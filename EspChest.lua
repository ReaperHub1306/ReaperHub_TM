-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

------------------------------------------------------------------------
-- CƠ CHẾ BẬT / TẮT (TOGGLE) & DỌN DẸP BỘ NHỚ
------------------------------------------------------------------------
if _G.EspChestEnabled then
    _G.EspChestEnabled = false
    
    -- Xóa toàn bộ ESP đang có trên màn hình
    local ChestFolder = Workspace:FindFirstChild("ChestFolderThing")
    if ChestFolder then
        for _, chest in ipairs(ChestFolder:GetChildren()) do
            if chest:FindFirstChild("ChestESP_GUI") then
                chest.ChestESP_GUI:Destroy()
            end
            if chest:FindFirstChild("ChestHighlight") then
                chest.ChestHighlight:Destroy()
            end
        end
    end
    
    -- Ngắt kết nối sự kiện thêm rương mới
    if _G.ChestAddedConnection then
        _G.ChestAddedConnection:Disconnect()
        _G.ChestAddedConnection = nil
    end
    return
end

_G.EspChestEnabled = true

------------------------------------------------------------------------
-- CẤU HÌNH ESP RƯƠNG
------------------------------------------------------------------------
local ChestFolder = Workspace:WaitForChild("ChestFolderThing", 10)

local ChestConfig = {
    ["GlitchChest_Spawn"] = { DisplayName = "Glitch Chest", Color = Color3.fromRGB(180, 50, 255), StrokeColor = Color3.fromRGB(255, 255, 255) },
    ["OmniversalChest_Spawn"] = { DisplayName = "Omniversal Chest", Color = Color3.fromRGB(255, 255, 255), StrokeColor = Color3.fromRGB(0, 255, 255) },
    ["TimeparadoxChest_Spawn"] = { DisplayName = "Time Paradox Chest", Color = Color3.fromRGB(150, 150, 150), StrokeColor = Color3.fromRGB(255, 255, 255) },
    ["RulerChest_Spawn"] = { DisplayName = "Ruler Chest", Color = Color3.fromRGB(255, 0, 0), StrokeColor = Color3.fromRGB(255, 255, 0) },
    ["RulerChest"] = { DisplayName = "Ruler Chest", Color = Color3.fromRGB(255, 0, 0), StrokeColor = Color3.fromRGB(255, 255, 0) },
    ["MachineChest_p"] = { DisplayName = "Machine Chest", Color = Color3.fromRGB(160, 160, 160), StrokeColor = Color3.fromRGB(255, 255, 255) }
}

local function createChestESP(chest)
    if not chest or not _G.EspChestEnabled then return end
    local config = ChestConfig[chest.Name]
    if not config or chest:FindFirstChild("ChestESP_GUI") then return end

    -- Nhận diện Part hiển thị
    local targetPart = chest:IsA("BasePart") and chest 
        or chest:FindFirstChild("Main2") 
        or chest:FindFirstChild("WoodenChest") 
        or chest:FindFirstChild("Handle") 
        or chest:FindFirstChildWhichIsA("BasePart")
    
    if not targetPart then return end

    -- Highlight xuyên tường
    local highlight = Instance.new("Highlight")
    highlight.Name = "ChestHighlight"
    highlight.Adornee = chest
    highlight.FillColor = config.Color
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = config.StrokeColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = chest

    -- BillboardGui hiển thị chữ xuyên tường
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ChestESP_GUI"
    billboard.Adornee = targetPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2000
    billboard.Parent = chest

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = config.Color
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = config.StrokeColor
    uiStroke.Thickness = 1.2
    uiStroke.Transparency = 0
    uiStroke.Parent = textLabel

    -- Vòng lặp cập nhật khoảng cách
    task.spawn(function()
        while _G.EspChestEnabled and chest and chest.Parent and targetPart and targetPart.Parent do
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = math.floor((root.Position - targetPart.Position).Magnitude)
                textLabel.Text = string.format("%s\n[%dm]", config.DisplayName, dist)
            else
                textLabel.Text = config.DisplayName
            end
            task.wait(0.1)
        end
    end)
end

-- Khởi chạy ESP cho các rương hiện có
if ChestFolder then
    for _, child in ipairs(ChestFolder:GetChildren()) do
        createChestESP(child)
    end
    
    -- Tự động nhận diện rương mới xuất hiện
    _G.ChestAddedConnection = ChestFolder.ChildAdded:Connect(function(child)
        task.wait(0.1)
        createChestESP(child)
    end)
end
