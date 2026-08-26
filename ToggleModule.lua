local function CreateToggleModule(container)
    local function AddToggle(btnName, rawUrl)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, 0, 0, 36)
        Container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Container.Parent = container

        local Corn = Instance.new("UICorner")
        Corn.CornerRadius = UDim.new(0, 4)
        Corn.Parent = Container

        local Strk = Instance.new("UIStroke")
        Strk.Color = Color3.fromRGB(60, 60, 60)
        Strk.Thickness = 1
        Strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Strk.Parent = Container

        local TextLbl = Instance.new("TextLabel")
        TextLbl.Size = UDim2.new(1, -60, 1, 0)
        TextLbl.Position = UDim2.new(0, 10, 0, 0)
        TextLbl.BackgroundTransparency = 1
        TextLbl.Text = btnName
        TextLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
        TextLbl.Font = Enum.Font.GothamMedium
        TextLbl.TextSize = 13
        TextLbl.TextXAlignment = Enum.TextXAlignment.Left
        TextLbl.Parent = Container

        local SwitchBtn = Instance.new("TextButton")
        SwitchBtn.Size = UDim2.new(0, 44, 0, 22)
        SwitchBtn.Position = UDim2.new(1, -54, 0.5, -11)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SwitchBtn.Text = ""
        SwitchBtn.AutoButtonColor = false
        SwitchBtn.Parent = Container

        local SwitchCorn = Instance.new("UICorner")
        SwitchCorn.CornerRadius = UDim.new(1, 0)
        SwitchCorn.Parent = SwitchBtn

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 18, 0, 18)
        Knob.Position = UDim2.new(0, 2, 0.5, -9)
        Knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        Knob.Parent = SwitchBtn

        local KnobCorn = Instance.new("UICorner")
        KnobCorn.CornerRadius = UDim.new(1, 0)
        KnobCorn.Parent = Knob

        local isOn = false
        SwitchBtn.MouseButton1Click:Connect(function()
            isOn = not isOn
            if isOn then
                SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                Knob:TweenPosition(UDim2.new(1, -20, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            else
                SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Knob:TweenPosition(UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            end
            loadstring(game:HttpGet(rawUrl))()
        end)
    end
    
    return AddToggle
end

return CreateToggleModule
