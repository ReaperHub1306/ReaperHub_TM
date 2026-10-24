-- ==========================================
-- REAPERHUB - AUTO CHEST MODULE (MOBILE FAST FARM)
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Biến kiểm soát trạng thái Auto Farm
_G.AutoChestEnabled = not _G.AutoChestEnabled

if not _G.AutoChestEnabled then
    if _G.CurrentChestHighlight then
        _G.CurrentChestHighlight:Destroy()
        _G.CurrentChestHighlight = nil
    end
    print("[ReaperHub] Auto Chest: DISABLED")
    return
end

print("[ReaperHub] Auto Chest: ENABLED")

-- 1. KIỂM TRA NHÂN VẬT SLENDERMAN
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

-- 2. TÌM RƯƠNG GẦN NHẤT TRONG BÁN KÍNH 350 STUDS
local function GetNearestChest()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = character.HumanoidRootPart
    local chestFolder = Workspace:FindFirstChild("ChestFolderThing")
    if not chestFolder then return nil end

    local nearestChest = nil
    local shortestDistance = 350 -- Đã tăng bán kính lên 350 studs

    for _, object in ipairs(chestFolder:GetChildren()) do
        if string.find(object.Name, "Chest") then
            local chestPos = nil
            if object:IsA("Model") then
                chestPos = object.PrimaryPart and object.PrimaryPart.Position or (object:FindFirstChildWhichIsA("BasePart") and object:FindFirstChildWhichIsA("BasePart").Position)
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

-- 3. TẠO HIGHLIGHT OUTLINE MỤC TIÊU
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

-- 4. DỊCH CHUYỂN SLENDERMAN
local function TeleportToPosition(targetPos)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local currentPos = hrp.Position
    local direction = (targetPos - currentPos).Unit
    local distance = (currentPos - targetPos).Magnitude

    local stepPos = currentPos + direction * (distance > 100 and 100 or distance)
    hrp.CFrame = CFrame.new(stepPos + Vector3.new(0, 1, 0))
end

-- 5. HÀM NHẶT RƯƠNG SIÊU TỐC CHO MOBILE (XỬ LÝ CẢ RƯƠNG BẤM GIỮ)
local function InteractChest(chest)
    if not chest then return end
    
    -- Tự động tìm ProximityPrompt bên trong Rương
    local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
    
    if prompt then
        -- Nếu Executor hỗ trợ hàm fireproximityprompt chuẩn
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            -- Phương pháp kích hoạt trực tiếp không bị mất Nút di chuyển Mobile
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration > 0 and (prompt.HoldDuration + 0.05) or 0.05)
                prompt:InputHoldEnd()
            end)
        end
    end
end

-- ==========================================
-- VÒNG LẶP AUTO FARM TỐC ĐỘ CAO
-- ==========================================
task.spawn(function()
    while _G.AutoChestEnabled do
        task.wait(0.15) -- Giảm trễ vòng lặp xuống 0.15s để tăng tốc độ farm

        if not IsSlenderman() then
            warn("[ReaperHub] Yêu cầu nhân vật Slenderman!")
            _G.AutoChestEnabled = false
            if _G.CurrentChestHighlight then _G.CurrentChestHighlight:Destroy() end
            break
        end

        local targetChest = GetNearestChest()

        if targetChest then
            HighlightChest(targetChest)

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

                    if dist > 8 then
                        TeleportToPosition(chestPos)
                        task.wait(0.3) -- Giảm thời gian chờ Teleport xuống 0.3s
                    else
                        -- Nhặt rương siêu tốc
                        InteractChest(targetChest)
                        task.wait(0.1)
                    end
                end
            end
        else
            if _G.CurrentChestHighlight then
                _G.CurrentChestHighlight.Adornee = nil
            end
        end
    end
end)
