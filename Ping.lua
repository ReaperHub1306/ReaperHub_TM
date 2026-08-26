local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- Nếu đã bật rồi -> Bấm lại sẽ TẮT (Toggle)
if CoreGui:FindFirstChild("StandalonePingGui") then
    if _G.PingScriptConnection then
        _G.PingScriptConnection:Disconnect()
        _G.PingScriptConnection = nil
    end
    CoreGui.StandalonePingGui:Destroy()
    return
end

-- Khởi tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StandalonePingGui"
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- TextLabel chuẩn vị trí, font và viền chữ đen như script gốc của bạn
local textLabel = Instance.new("TextLabel")
textLabel.Name = "PingDisplay"
textLabel.Size = UDim2.new(0, 250, 0, 30)
textLabel.Position = UDim2.new(0.35, 0, 0, 16)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextStrokeTransparency = 0
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 20
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.Parent = screenGui

-- Vòng lặp cập nhật Ping
_G.PingScriptConnection = RunService.RenderStepped:Connect(function()
    if not screenGui or not screenGui.Parent then
        if _G.PingScriptConnection then
            _G.PingScriptConnection:Disconnect()
            _G.PingScriptConnection = nil
        end
        return
    end

    local pingValue = math.floor(localPlayer:GetNetworkPing() * 1000)
    local pingIcon = "🔴"
    
    if pingValue <= 100 then
        pingIcon = "🟢"
    elseif pingValue <= 150 then
        pingIcon = "🟡"
    elseif pingValue <= 200 then
        pingIcon = "🟠"
    end

    textLabel.Text = string.format("%s Ping : %d ms", pingIcon, pingValue)
end)
