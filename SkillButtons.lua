-- ==========================================
-- REAPERHUB - CUSTOM SKILL BUTTONS MODULE
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ReaperHub_SkillButtons") then
    CoreGui.ReaperHub_SkillButtons:Destroy()
end

if not _G.ReaperHubConfig or not _G.ReaperHubConfig.SkillButtonsActive then
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub_SkillButtons"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

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

_G.ReaperHubConfig.SkillButtons = _G.ReaperHubConfig.SkillButtons or {}
_G.ReaperHubConfig.SkillButtons[currentTroll] = _G.ReaperHubConfig.SkillButtons[currentTroll] or {
    {name = "S1", tool = "", pos = {x = 0.8, y = 0.4}, size = 58, displayText = "S1"}
}

local trollConfig = _G.ReaperHubConfig.SkillButtons[currentTroll]

for index, data in ipairs(trollConfig) do
    local btnSize = tonumber(data.size) or 58
    
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Name = "SkillBtn_" .. index
    CircleBtn.Size = UDim2.new(0, btnSize, 0, btnSize)
    CircleBtn.Position = UDim2.new(data.pos.x or 0.8, 0, data.pos.y or (0.3 + index * 0.15), 0)
    
    -- SỬA MÀU SẮC CHO DỄ NHÌN, KHÔNG BỊ CHÓI
    CircleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    CircleBtn.BackgroundTransparency = 0.25
    CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Hiển thị chữ tùy chỉnh hoặc tên tool rút gọn
    local labelTxt = data.displayText
    if not labelTxt or labelTxt == "" then
        labelTxt = (data.tool and data.tool ~= "") and string.sub(data.tool, 1, 4) or ("S" .. index)
    end
    CircleBtn.Text = labelTxt
    CircleBtn.Font = Enum.Font.GothamBold
    CircleBtn.TextSize = math.clamp(math.floor(btnSize * 0.28), 10, 18)
    CircleBtn.Active = true
    CircleBtn.Parent = ScreenGui

    Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
    
    local Stroke = Instance.new("UIStroke", CircleBtn)
    Stroke.Color = Color3.fromRGB(220, 220, 220)
    Stroke.Transparency = 0.3
    Stroke.Thickness = 1.8

    -- Kéo thả định vị trí nút
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
            if dragging then
                dragging = false
                data.pos.x = CircleBtn.Position.X.Scale
                data.pos.y = CircleBtn.Position.Y.Scale
                if _G.ReaperHub_SaveConfig then
                    _G.ReaperHub_SaveConfig()
                end
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and _G.ReaperHub_MoveMode and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            local parentSize = ScreenGui.AbsoluteSize
            local newX = math.clamp((startPos.X.Scale * parentSize.X + startPos.X.Offset + delta.X) / parentSize.X, 0, 0.88)
            local newY = math.clamp((startPos.Y.Scale * parentSize.Y + startPos.Y.Offset + delta.Y) / parentSize.Y, 0, 0.88)
            
            CircleBtn.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)

    -- Kích hoạt Skill/Tool khi bấm
    CircleBtn.Activated:Connect(function()
        if _G.ReaperHub_MoveMode then return end
        if data.tool and data.tool ~= "" then
            local character = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if character and backpack then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local tool = character:FindFirstChild(data.tool) or backpack:FindFirstChild(data.tool)
                
                if tool and humanoid then
                    if tool.Parent == backpack then
                        humanoid:EquipTool(tool)
                        task.wait(0.05)
                    end
                    if tool:IsA("Tool") then
                        pcall(function()
                            tool:Activate()
                        end)
                    end
                end
            end
        end
    end)
end
