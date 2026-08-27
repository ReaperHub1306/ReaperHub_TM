local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Cơ chế Bật/Tắt chuẩn ReaperHub
if _G.ItemScannerEnabled then
    _G.ItemScannerEnabled = false
    if CoreGui:FindFirstChild("ItemScannerGUI") then
        CoreGui.ItemScannerGUI:Destroy()
    end
    return
end

_G.ItemScannerEnabled = true

-- Xóa GUI cũ nếu đã chạy trước đó
if CoreGui:FindFirstChild("ItemScannerGUI") then
    CoreGui.ItemScannerGUI:Destroy()
end

-- ==========================================
-- 1. TẠO GIAO DIỆN HIỆN ĐẠI (UPGRADED REAPERHUB THEME)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ItemScannerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Nút Thu gọn / Mở rộng (MỚI VÀO TRẠNG THÁI DẤU "+")
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 42, 0, 22)
ToggleBtn.Position = UDim2.new(0.8, 0, 0.05, -60) -- Vị trí chuẩn gốc của bạn
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleBtn.Text = "+"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
ToggleBtn.AutoButtonColor = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.2
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleStroke.Parent = ToggleBtn

-- Khung Main (MỚI BẬT LÊN SẼ TỰ ĐỘNG THU GỌN / ẨN ĐI)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 260)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- Bắt đầu ở trạng thái ẩn/thu gọn
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Đường kẻ dọc chia đôi hiện đại
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 1, 1, -20)
Divider.Position = UDim2.new(0.5, 0, 0, 10)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Ô Tìm kiếm (SearchBox Modern)
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0, 195, 0, 34)
SearchBox.Position = UDim2.new(0, 12, 0, 12)
SearchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
SearchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
SearchBox.PlaceholderText = "Search item..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 13
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 4)
SearchBoxCorner.Parent = SearchBox

local SearchBoxStroke = Instance.new("UIStroke")
SearchBoxStroke.Color = Color3.fromRGB(60, 60, 60)
SearchBoxStroke.Thickness = 1
SearchBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchBoxStroke.Parent = SearchBox

-- Hiển thị số lượng Player
local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Name = "PlayerCountLabel"
PlayerCountLabel.Size = UDim2.new(0, 95, 0, 26)
PlayerCountLabel.Position = UDim2.new(0, 12, 0, 52)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
PlayerCountLabel.Text = "player: 0"
PlayerCountLabel.Font = Enum.Font.GothamMedium
PlayerCountLabel.TextSize = 13
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerCountLabel.Parent = MainFrame

-- Nút Chế độ (ModeBtn)
local currentMode = "items"

local ModeBtn = Instance.new("TextButton")
ModeBtn.Name = "ModeBtn"
ModeBtn.Size = UDim2.new(0, 94, 0, 26)
ModeBtn.Position = UDim2.new(0, 113, 0, 52)
ModeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
ModeBtn.Text = "items >"
ModeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
ModeBtn.Font = Enum.Font.GothamMedium
ModeBtn.TextSize = 12
ModeBtn.Parent = MainFrame

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 4)
ModeCorner.Parent = ModeBtn

local ModeStroke = Instance.new("UIStroke")
ModeStroke.Color = Color3.fromRGB(60, 60, 60)
ModeStroke.Thickness = 1
ModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ModeStroke.Parent = ModeBtn

-- Menu Dropdown
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Size = UDim2.new(0, 94, 0, 52)
DropdownFrame.Position = UDim2.new(0, 113, 0, 81)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
DropdownFrame.Visible = false
DropdownFrame.ZIndex = 10
DropdownFrame.Parent = MainFrame

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 4)
DropdownCorner.Parent = DropdownFrame

local DropdownStroke = Instance.new("UIStroke")
DropdownStroke.Color = Color3.fromRGB(60, 60, 60)
DropdownStroke.Thickness = 1
DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DropdownStroke.Parent = DropdownFrame

local ItemsOptionBtn = Instance.new("TextButton")
ItemsOptionBtn.Size = UDim2.new(1, 0, 0.5, 0)
ItemsOptionBtn.BackgroundTransparency = 1
ItemsOptionBtn.Text = "items"
ItemsOptionBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
ItemsOptionBtn.Font = Enum.Font.GothamMedium
ItemsOptionBtn.TextSize = 12
ItemsOptionBtn.ZIndex = 11
ItemsOptionBtn.Parent = DropdownFrame

local TrollsOptionBtn = Instance.new("TextButton")
TrollsOptionBtn.Size = UDim2.new(1, 0, 0.5, 0)
TrollsOptionBtn.Position = UDim2.new(0, 0, 0.5, 0)
TrollsOptionBtn.BackgroundTransparency = 1
TrollsOptionBtn.Text = "trolls"
TrollsOptionBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
TrollsOptionBtn.Font = Enum.Font.GothamMedium
TrollsOptionBtn.TextSize = 12
TrollsOptionBtn.ZIndex = 11
TrollsOptionBtn.Parent = DropdownFrame

-- Khung chứa 8 ô gợi ý
local SuggestionsFrame = Instance.new("Frame")
SuggestionsFrame.Name = "SuggestionsFrame"
SuggestionsFrame.Size = UDim2.new(0, 195, 0, 160)
SuggestionsFrame.Position = UDim2.new(0, 12, 0, 85)
SuggestionsFrame.BackgroundTransparency = 1
SuggestionsFrame.Parent = MainFrame

local SuggestionLayout = Instance.new("UIGridLayout")
SuggestionLayout.Parent = SuggestionsFrame
SuggestionLayout.CellSize = UDim2.new(0, 92, 0, 36)
SuggestionLayout.CellPadding = UDim2.new(0, 11, 0, 5)
SuggestionLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ScrollingFrame Danh sách Người chơi
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(0, 205, 0, 236)
ScrollFrame.Position = UDim2.new(0.5, 15, 0, 12)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- ==========================================
-- 2. HÀM XỬ LÝ CHUỖI & VIẾT TẮT (ACRONYM)
-- ==========================================
local function cleanText(str)
    if not str then return "" end
    local t = tostring(str):lower()
    t = t:gsub("^%s*(.-)%s*$", "%1")
    t = t:gsub("%s+", " ")
    return t
end

local function getAcronym(str)
    if not str then return "" end
    local acronym = ""
    for word in tostring(str):gmatch("%w+") do
        local firstChar = word:sub(1, 1)
        acronym = acronym .. firstChar
    end
    return acronym
end

-- ==========================================
-- 3. LOGIC TÌM KIẾM
-- ==========================================
local function PerformSearch()
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    
    for _, child in ipairs(SuggestionsFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end

    local rawText = SearchBox.Text
    if rawText == "" or rawText == "..." then
        PlayerCountLabel.Text = "player: 0"
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        return
    end

    local query = cleanText(rawText)
    if query == "" then return end

    local totalPlayersOwning = 0
    local listIndex = 1
    local uniqueItemsFound = {}

    local targetFolder = (currentMode == "items") and "ItemSaves" or "TrollgeSaves"
    local maxSaves = (currentMode == "items") and 35 or 25

    for _, player in ipairs(Players:GetPlayers()) do
        local savesFolder = player:FindFirstChild(targetFolder)
        if savesFolder then
            local itemCount = 0
            
            for i = 1, maxSaves do
                local saveFile = savesFolder:FindFirstChild("save" .. tostring(i))
                
                if saveFile and (saveFile:IsA("StringValue") or saveFile:IsA("ValueBase")) then
                    local originalValue = tostring(saveFile.Value)
                    local cleanedValue = cleanText(originalValue)
                    local acronymValue = cleanText(getAcronym(originalValue))
                    
                    if string.find(cleanedValue, query, 1, true) or string.find(acronymValue, query, 1, true) then
                        itemCount = itemCount + 1
                        if not uniqueItemsFound[cleanedValue] then
                            uniqueItemsFound[cleanedValue] = originalValue
                        end
                    end
                end
            end

            if itemCount > 0 then
                totalPlayersOwning = totalPlayersOwning + 1
                
                local PlayerLabel = Instance.new("TextLabel")
                PlayerLabel.Size = UDim2.new(1, 0, 0, 26)
                PlayerLabel.BackgroundTransparency = 1
                PlayerLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                PlayerLabel.Font = Enum.Font.GothamMedium
                PlayerLabel.TextSize = 13
                PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
                PlayerLabel.Text = tostring(listIndex) .. ". " .. player.Name .. " x" .. tostring(itemCount)
                PlayerLabel.Parent = ScrollFrame
                
                listIndex = listIndex + 1
            end
        end
    end

    local count = 0
    for _, originalName in pairs(uniqueItemsFound) do
        if count >= 8 then break end
        
        local acr = getAcronym(originalName):upper()
        
        local SuggestionBtn = Instance.new("TextButton")
        SuggestionBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        SuggestionBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        SuggestionBtn.Text = acr .. "\n(" .. originalName .. ")"
        SuggestionBtn.Font = Enum.Font.GothamMedium
        SuggestionBtn.TextScaled = true
        SuggestionBtn.TextWrapped = true
        SuggestionBtn.Parent = SuggestionsFrame
        
        local SugCorner = Instance.new("UICorner")
        SugCorner.CornerRadius = UDim.new(0, 4)
        SugCorner.Parent = SuggestionBtn
        
        local SugStroke = Instance.new("UIStroke")
        SugStroke.Color = Color3.fromRGB(60, 60, 60)
        SugStroke.Thickness = 1
        SugStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        SugStroke.Parent = SuggestionBtn
        
        SuggestionBtn.MouseButton1Click:Connect(function()
            SearchBox.Text = originalName
            PerformSearch()
        end)
        
        count = count + 1
    end

    PlayerCountLabel.Text = "player: " .. tostring(totalPlayersOwning)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(PerformSearch)

-- ==========================================
-- 4. XỬ LÝ SỰ KIỆN MENU & BẬT TẮT
-- ==========================================
ModeBtn.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    if DropdownFrame.Visible then
        ModeBtn.Text = currentMode .. " v"
    else
        ModeBtn.Text = currentMode .. " >"
    end
end)

ItemsOptionBtn.MouseButton1Click:Connect(function()
    currentMode = "items"
    ModeBtn.Text = "items >"
    DropdownFrame.Visible = false
    PerformSearch()
end)

TrollsOptionBtn.MouseButton1Click:Connect(function()
    currentMode = "trolls"
    ModeBtn.Text = "trolls >"
    DropdownFrame.Visible = false
    PerformSearch()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleBtn.Text = "-"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    else
        ToggleBtn.Text = "+"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)
