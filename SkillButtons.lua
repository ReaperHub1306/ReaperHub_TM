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

-- Nếu chưa bật hệ thống nút thì dừng
if not _G.ReaperHubConfig or not _G.ReaperHubConfig.SkillButtonsActive then
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub_SkillButtons"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Lấy tên Troll hiện tại để phân tách dữ liệu riêng biệt
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
    {name = "S1", tool = "", pos = {x = 0.8, y = 0.4}},
    {name = "S2", tool = "", pos = {x = 0.8, y = 0.55}}
}

local trollConfig = _G.ReaperHubConfig.SkillButtons[currentTroll]

-- Vẽ các nút tròn lên màn hình
for index, data in ipairs(trollConfig) do
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Name = "SkillBtn_" .. index
    CircleBtn.Size = UDim2.new(0, 58, 0, 58) -- Tăng kích thước nút tròn chút cho dễ bấm trên mobile
    CircleBtn.Position = UDim2.new(data.pos.x or 0.8, 0, data.pos.y or (0.3 + index * 0.15), 0)
    CircleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CircleBtn.Text = (data.tool and data.tool ~= "") and string.sub(data.tool, 1, 4) or ("S" .. index)
    CircleBtn.Font = Enum.Font.GothamBold
    CircleBtn.TextSize = 12
    CircleBtn.Active = true
    CircleBtn.Parent = ScreenGui

    Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
    
    local Stroke = Instance.new("UIStroke", CircleBtn)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 1.5

    -- Kéo thả nút khi bật chế độ Move Button
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
                -- TỰ ĐỘNG LƯU VỊ TRÍ KHI KÉO THẢ XONG
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
            local newX = math.clamp((startPos.X.Scale * parentSize.X + startPos.X.Offset + delta.X) / parentSize.X, 0, 0.85)
            local newY = math.clamp((startPos.Y.Scale * parentSize.Y + startPos.Y.Offset + delta.Y) / parentSize.Y, 0, 0.85)
            
            CircleBtn.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)

    -- CƠ CHẾ DÙNG SKILL: Trang bị tool lên tay VÀ kích hoạt hành động (Activate) ngay lập tức
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
