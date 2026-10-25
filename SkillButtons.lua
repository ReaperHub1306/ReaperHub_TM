-- ==========================================
-- REAPERHUB - CUSTOM SKILL BUTTONS MODULE
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu bật lại
if CoreGui:FindFirstChild("ReaperHub_SkillButtons") then
    CoreGui.ReaperHub_SkillButtons:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub_SkillButtons"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Lấy tên Troll hiện tại để phân tách config riêng biệt
local function GetCurrentTroll()
    local pcallSuccess, trollName = pcall(function()
        return LocalPlayer.trollge_data.troll_stand.Value
    end)
    if pcallSuccess and trollName and trollName ~= "" then
        return tostring(trollName)
    end
    return "Default"
end

-- Khởi tạo cấu hình nút cho từng con Troll trong _G.ReaperHubConfig
_G.ReaperHubConfig.SkillButtons = _G.ReaperHubConfig.SkillButtons or {}

local function GetCurrentTrollButtons()
    local troll = GetCurrentTroll()
    _G.ReaperHubConfig.SkillButtons[troll] = _G.ReaperHubConfig.SkillButtons[troll] or {
        {name = "Skill 1", tool = "", pos = {x = 0.1, y = 0.4}},
        {name = "Skill 2", tool = "", pos = {x = 0.1, y = 0.55}}
    }
    return _G.ReaperHubConfig.SkillButtons[troll]
end

-- Biến trạng thái chế độ di chuyển nút (Move Button)
_G.ReaperHub_MoveMode = _G.ReaperHub_MoveMode or false

local activeButtons = {}

local function RefreshButtons()
    -- Xóa các nút hiển thị cũ trên màn hình
    for _, btnObj in ipairs(activeButtons) do
        if btnObj then btnObj:Destroy() end
    end
    activeButtons = {}

    local trollConfig = GetCurrentTrollButtons()

    for index, data in ipairs(trollConfig) do
        -- Tạo nút tròn trên màn hình
        local CircleBtn = Instance.new("TextButton")
        CircleBtn.Size = UDim2.new(0, 55, 0, 55)
        CircleBtn.Position = UDim2.new(data.pos.x, 0, data.pos.y, 0)
        CircleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CircleBtn.Text = data.name
        CircleBtn.Font = Enum.Font.GothamBold
        CircleBtn.TextSize = 12
        CircleBtn.Active = true
        CircleBtn.Draggable = false -- Tự xử lý kéo thả mượt mà trên Mobile
        CircleBtn.Parent = ScreenGui

        Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
        local Stroke = Instance.new("UIStroke", CircleBtn)
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        Stroke.Thickness = 1.5

        -- Xử lý Kéo thả khi bật Move Mode
        local dragging = false
        local dragInput, dragStart, startPos

        CircleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if _G.ReaperHub_MoveMode then
                    dragging = true
                    dragStart = input.Position
                    startPos = CircleBtn.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end
        end)

        CircleBtn.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging and _G.ReaperHub_MoveMode then
                local delta = input.Position - dragStart
                local parentSize = ScreenGui.AbsoluteSize
                local newX = math.clamp((startPos.X.Scale * parentSize.X + startPos.X.Offset + delta.X) / parentSize.X, 0, 0.9)
                local newY = math.clamp((startPos.Y.Scale * parentSize.Y + startPos.Y.Offset + delta.Y) / parentSize.Y, 0, 0.9)
                
                CircleBtn.Position = UDim2.new(newX, 0, newY, 0)
                data.pos.x = newX
                data.pos.y = newY
                if _G.ReaperHubConfig.AutoSave and SaveConfig then SaveConfig() end
            end
        end)

        -- Xử lý bấm nút để dùng Skill (Equip Tool từ Backpack)
        CircleBtn.Activated:Connect(function()
            if _G.ReaperHub_MoveMode then return end
            if data.tool and data.tool ~= "" then
                local character = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if character and backpack then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local tool = backpack:FindFirstChild(data.tool) or character:FindFirstChild(data.tool)
                    if tool and humanoid then
                        humanoid:EquipTool(tool)
                    end
                end
            end
        end)

        table.insert(activeButtons, CircleBtn)
    end
end

RefreshButtons()
print("[ReaperHub] Custom Skill Buttons loaded for Troll: " .. GetCurrentTroll())
