-- ==========================================
-- REAPERHUB - AUTO CHEST MODULE (SLENDERMAN)
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Biến kiểm soát vòng lặp Auto Farm
_G.AutoChestEnabled = not _G.AutoChestEnabled

if not _G.AutoChestEnabled then
    -- Xóa Highlight cũ nếu người chơi TẮT Auto
    if _G.CurrentChestHighlight then
        _G.CurrentChestHighlight:Destroy()
        _G.CurrentChestHighlight = nil
    end
    print("[ReaperHub] Auto Chest: DISABLED")
    return
end

print("[ReaperHub] Auto Chest: ENABLED")

-- 1. HÀM KIỂM TRA NHÂN VẬT CÓ PHẢI SLENDERMAN KHÔNG
local function IsSlenderman()
    local trollData = LocalPlayer:FindFirstChild("trollge_data")
    if trollData then
        local trollStand = trollData:FindFirstChild("troll_stand")
        if trollStand and trollStand.Value == "Slenderman" then
            return true
        end
    end
    return false
end

-- 2. HÀM TÌM RƯƠNG GẦN NHẤT TRONG BÁN KÍNH 300 STUDS
local function GetNearestChest()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = character.HumanoidRootPart
    local chestFolder = Workspace:FindFirstChild("ChestFolderThing")
    if not chestFolder then return nil end

    local nearestChest = nil
    local shortestDistance = 300 -- Giới hạn tối đa 300 studs (Chống dính rương bẫy ngoài Map)

    for _, object in ipairs(chestFolder:GetChildren()) do
        -- Kiểm tra tên chứa chữ "Chest"
        if string.find(object.Name, "Chest") then
            -- Lấy vị trí của Rương (Model hoặc Part)
            local chestPos = nil
            if object:IsA("Model") then
                chestPos = object.PrimaryPart and object.PrimaryPart.Position or object:GetAttribute("Pivot") or (object:FindFirstChildWhichIsA("BasePart") and object:FindFirstChildWhichIsA("BasePart").Position)
            elseif object:IsA("BasePart") then
                chestPos = object.Position
            end

            if chestPos then
                local distance = (hrp.Position - chestPos).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestChest = object
                end
            end
        end
    end

    return nearestChest
end

-- 3. HÀM TẠO OUTLINE HIGHLIGHT VIỀN SÁNG CHO RƯƠNG MỤC TIÊU
local function HighlightChest(chest)
    if not _G.CurrentChestHighlight then
        _G.CurrentChestHighlight = Instance.new("Highlight")
        _G.CurrentChestHighlight.Name = "ReaperHub_ChestHighlight"
        _G.CurrentChestHighlight.FillColor = Color3.fromRGB(255, 255, 255)
        _G.CurrentChestHighlight.FillTransparency = 0.5
        _G.CurrentChestHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        _G.CurrentChestHighlight.OutlineTransparency = 0
    end
    _G.CurrentChestHighlight.Adornee = chest
    _G.CurrentChestHighlight.Parent = chest
end

-- 4. HÀM THỰC THI TELEPORT (MÔ PHỎNG DỰA TÊN SCRIPT TOOL SLENDERMAN)
local function TeleportToPosition(targetPos)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local currentPos = hrp.Position
    local direction = (targetPos - currentPos).Unit
    local distance = (currentPos - targetPos).Magnitude

    -- Tăng khoảng cách dịch chuyển tối đa theo cơ chế của Tool Slenderman
    local stepPos = currentPos + direction * (distance > 100 and 100 or distance)
    hrp.CFrame = CFrame.new(stepPos + Vector3.new(0, 1, 0))
end

-- 5. HÀM MÔ PHỎNG BẤM PHÍM "E" ĐỂ NHẶT RƯƠNG
local function PressE()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

-- ==========================================
-- VÒNG LẶP AUTO FARM CHÍNH
-- ==========================================
task.spawn(function()
    while _G.AutoChestEnabled do
        task.wait(0.3)

        -- Check 1: Phải đang dùng nhân vật Slenderman
        if not IsSlenderman() then
            warn("[ReaperHub] Yêu cầu nhân vật Slenderman để kích hoạt Auto Chest!")
            _G.AutoChestEnabled = false
            if _G.CurrentChestHighlight then _G.CurrentChestHighlight:Destroy() end
            break
        end

        -- Check 2: Tìm rương hợp lệ trong bán kính <= 300 studs
        local targetChest = GetNearestChest()

        if targetChest then
            -- Bật viền sáng Outline cho rương mục tiêu
            HighlightChest(targetChest)

            -- Lấy vị trí Rương
            local chestPos = nil
            if targetChest:IsA("Model") then
                chestPos = targetChest.PrimaryPart and targetChest.PrimaryPart.Position or (targetChest:FindFirstChildWhichIsA("BasePart") and targetChest:FindFirstChildWhichIsA("BasePart").Position)
            elseif targetChest:IsA("BasePart") then
                chestPos = targetChest.Position
            end

            if chestPos then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (character.HumanoidRootPart.Position - chestPos).Magnitude

                    -- Nếu còn xa rương -> Dịch chuyển lại gần
                    if dist > 8 then
                        TeleportToPosition(chestPos)
                        task.wait(0.5) -- Đợi hồi chiêu Teleport của Slenderman
                    else
                        -- Đã ở sát Rương -> Bấm E nhặt rương
                        PressE()
                        task.wait(0.2)
                    end
                end
            end
        else
            -- Nếu không tìm thấy rương nào trong phạm vi 300 studs -> Ẩn Highlight
            if _G.CurrentChestHighlight then
                _G.CurrentChestHighlight.Adornee = nil
            end
        end
    end
end)
