-- ==========================================
-- REAPERHUB - CUSTOM SKILL BUTTONS MODULE
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Xóa ScreenGui nút cũ nếu đã tồn tại
if CoreGui:FindFirstChild("ReaperHub_SkillButtons") then
    CoreGui.ReaperHub_SkillButtons:Destroy()
end

-- Tắt hệ thống nút nếu biến Toggle là false
if not _G.ReaperHubConfig or not _G.ReaperHubConfig.SkillButtonsActive then
    print("[ReaperHub] Skill Buttons: OFF")
    return
end

print("[ReaperHub] Skill Buttons: ON")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub_SkillButtons"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Lấy tên Troll hiện tại của người chơi
local function GetCurrentTroll()
    local success, trollName = pcall(function()
        return LocalPlayer.trollge_data.troll_stand.Value
    end)
    if success and trollName and trollName ~= "" then
        return tostring(trollName)
    end
    return "Default"
end

local currentTroll = GetCurrentTroll()

-- Đảm bảo bảng config SkillButtons được khởi tạo chuẩn
_G.ReaperHubConfig.SkillButtons = _G.ReaperHubConfig.SkillButtons or {}
_G.ReaperHubConfig.SkillButtons[currentTroll] = _G.ReaperHubConfig.SkillButtons[currentTroll] or {
    {name = "S1", tool = "", pos = {x = 0.8, y = 0.4}},
    {name = "S2", tool = "", pos = {x = 0.8, y = 0.55}}
}

local trollConfig = _G.ReaperHubConfig.SkillButtons[currentTroll]

-- VẼ CÁC NÚT TRÒN LÊN MÀN HÌNH
for index, data in ipairs(trollConfig) do
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Name = "SkillBtn_" .. index
    CircleBtn.Size = UDim2.new(0, 52, 0, 52)
    CircleBtn.Position = UDim2.new(data.pos.x or 0.8, 0, data.pos.y or (0.3 + index * 0.15), 0)
    CircleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CircleBtn.Text = (data.tool and data.tool ~= "") and string.sub(data.tool, 1, 4) or ("S" .. index)
    CircleBtn.Font = Enum.Font.GothamBold
    CircleBtn.TextSize = 11
    CircleBtn.Active = true
    CircleBtn.Parent = ScreenGui

    Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
    
    local Stroke = Instance.new("UIStroke", CircleBtn)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 1.5

    -- Kéo thả nút khi bật Move Button
    local dragging = false
    local dragStart, startPos

    CircleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if _G.ReaperHub_MoveMode then
                dragging = true
                dragStart = input.Position
                startPos = CircleBtn.Position
            end
        end
    end)

    CircleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and _G.ReaperHub_MoveMode and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            local parentSize = ScreenGui.AbsoluteSize
            local newX = math.clamp((startPos.X.Scale * parentSize.X + startPos.X.Offset + delta.X) / parentSize.X, 0, 0.85)
            local newY = math.clamp((startPos.Y.Scale * parentSize.Y + startPos.Y.Offset + delta.Y) / parentSize.Y, 0, 0.85)
            
            CircleBtn.Position = UDim2.new(newX, 0, newY, 0)
            data.pos.x = newX
            data.pos.y = newY
        end
    end)

    -- Khi bấm nút -> Cầm Tool tương ứng
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
end
