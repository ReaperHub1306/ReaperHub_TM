local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- Nếu đã bật rồi -> Chạy lại sẽ TẮT và dọn dẹp bộ nhớ
if CoreGui:FindFirstChild("StandalonePingGui") then
    if _G.PingScriptConnection then
        _G.PingScriptConnection:Disconnect()
        _G.PingScriptConnection = nil
    end
    CoreGui.StandalonePingGui:Destroy()
    return
end

-- BẬT GUI PING
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StandalonePingGui"
screenGui.Parent = CoreGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 130, 0, 32)
textLabel.Position = UDim2.new(0.5, -65, 0, 10)
textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
textLabel.BackgroundTransparency = 0.3
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 13
textLabel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = textLabel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1
stroke.Parent = textLabel

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

    textLabel.Text = string.format("%s Ping: %d ms", pingIcon, pingValue)
end)
