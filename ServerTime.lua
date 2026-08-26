local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- BẤM LẠI LẦN 2 SẼ TẮT (TOGGLE & CLEAN MEMORY)
if CoreGui:FindFirstChild("StandaloneServerTimeGui") then
    if _G.ServerTimeConnection then
        _G.ServerTimeConnection:Disconnect()
        _G.ServerTimeConnection = nil
    end
    CoreGui.StandaloneServerTimeGui:Destroy()
    return
end

-- KHỞI TẠO GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StandaloneServerTimeGui"
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TimeDisplay"
textLabel.Size = UDim2.new(0, 250, 0, 30)
-- Tọa độ Y = 42 để không bị đè lên dòng Ping (Y = 16) khi bật cả 2 nút
textLabel.Position = UDim2.new(0.35, 0, 0, 42)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextStrokeTransparency = 0
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 20
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.Parent = screenGui

local clockIcons = {"🕛", "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚"}

_G.ServerTimeConnection = RunService.RenderStepped:Connect(function()
    if not screenGui or not screenGui.Parent then
        if _G.ServerTimeConnection then
            _G.ServerTimeConnection:Disconnect()
            _G.ServerTimeConnection = nil
        end
        return
    end

    local timeFormatted = "Đang tải..."
    local currentSecond = 0

    local success, result = pcall(function()
        local timeTextObj = playerGui:FindFirstChild("menu") 
            and playerGui.menu:FindFirstChild("holder") 
            and playerGui.menu.holder:FindFirstChild("Time")
        
        if timeTextObj and timeTextObj:IsA("TextLabel") then
            local rawText = timeTextObj.Text
            local h, m, s = string.match(rawText, "(%d+):(%d+):(%d+)")
            
            if h and m and s then
                currentSecond = tonumber(s) or 0
                return string.format("%sh : %sp : %ss", h, m, s)
            else
                return rawText
            end
        end
    end)

    if success and result then 
        timeFormatted = result 
    end

    local clockIcon = clockIcons[(currentSecond % 12) + 1]
    textLabel.Text = string.format("%s %s", clockIcon, timeFormatted)
end)
