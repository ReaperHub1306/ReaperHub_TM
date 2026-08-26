local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- TOGGLE & DỌN BỘ NHỚ
if CoreGui:FindFirstChild("ChestTrackerGui") then
    _G.ChestStatRunning = false
    CoreGui.ChestTrackerGui:Destroy()
    return
end

_G.ChestStatRunning = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChestTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.Parent = CoreGui

-- Khung chứa danh sách (Đã tắt kéo thả, giữ cố định vị trí)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 70)
mainFrame.Position = UDim2.new(0.02, 0, 0.16, 0) -- Vị trí cố định chuẩn
mainFrame.BackgroundTransparency = 1
mainFrame.Active = false
mainFrame.Draggable = false -- Tắt tính năng kéo thả
mainFrame.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 0)
listLayout.Parent = mainFrame

local function createChestLabel(name, layoutOrder, textColor, strokeColor)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 20
    label.TextColor3 = textColor
    label.LayoutOrder = layoutOrder

    if strokeColor then
        label.TextStrokeColor3 = strokeColor
        label.TextStrokeTransparency = 0
    else
        label.TextStrokeTransparency = 1
    end

    label.Parent = mainFrame
    return label
end

local chestLabel = createChestLabel("ChestLabel", 1, Color3.fromRGB(139, 69, 19), Color3.fromRGB(255, 255, 0))
local darkChestLabel = createChestLabel("DarkChestLabel", 2, Color3.fromRGB(0, 0, 0), Color3.fromRGB(160, 32, 240))
local lightChestLabel = createChestLabel("LightChestLabel", 3, Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255))

local function updateChestCount()
    local folder = Workspace:FindFirstChild("ChestFolderThing")
    
    if not folder then
        chestLabel.Text = "Chest: 0"
        darkChestLabel.Text = "Dark Chest: 0"
        lightChestLabel.Text = "Light Chest: 0"
        return
    end

    local chestCount = 0
    local darkChestCount = 0
    local lightChestCount = 0

    for _, item in ipairs(folder:GetChildren()) do
        local itemName = item.Name
        if itemName == "Chest_Spawn" or itemName == "Chest" then
            chestCount = chestCount + 1
        elseif itemName == "DarkChest_Spawn" or itemName == "DarkChest" or itemName == "Dark Chest" then
            darkChestCount = darkChestCount + 1
        elseif itemName == "LightChest_Spawn" or itemName == "LightChest" or itemName == "Light Chest" then
            lightChestCount = lightChestCount + 1
        end
    end

    chestLabel.Text = "Chest: " .. chestCount
    darkChestLabel.Text = "Dark Chest: " .. darkChestCount
    lightChestLabel.Text = "Light Chest: " .. lightChestCount
end

task.spawn(function()
    while _G.ChestStatRunning and screenGui and screenGui.Parent do
        updateChestCount()
        task.wait(0.5)
    end
end)
