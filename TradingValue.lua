local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local guiName = "TradeTrackerGUI"

-- ==========================================
-- XỬ LÝ BẬT / TẮT (TOGGLE ON/OFF)
-- ==========================================
if getgenv().ReaperHub_TradeTracker_Loaded then
    local existingGui = CoreGui:FindFirstChild(guiName) or LocalPlayer.PlayerGui:FindFirstChild(guiName)
    if existingGui then
        existingGui.Enabled = not existingGui.Enabled
    end
    return
end

getgenv().ReaperHub_TradeTracker_Loaded = true

if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end

-- ==========================================
-- BẢNG VALUE MỚI NHẤT (TỪ TIERLIST GOOGLE DOCS)
-- ==========================================
local ValueTable = {
    -- SS+ Tier
    ["bob cup"] = 70000,
    ["source of all creation"] = 50000,
    ["soac"] = 50000,
    ["rob cup"] = 38000,
    ["rob"] = 30000,
    ["equinox evil"] = 16000,
    ["equinox:evil"] = 16000,
    ["equinox"] = 16000,
    ["sunglasses"] = 12000,

    -- SS Tier
    ["reaper essence"] = 8500,
    ["true ruler spirit"] = 6250,
    ["bob"] = 5800,
    ["hollow trolling:fire"] = 4250,
    ["hollow trolling fire"] = 4250,
    ["hollow trolling:flandre"] = 4250,
    ["hollow trolling flandre"] = 4250,
    ["hollow trolling"] = 4250,
    ["halloween chest"] = 3000,
    ["kindness soul"] = 2700,
    ["trollge:true potential's"] = 2600,
    ["trollge:true potential"] = 2600,
    ["trollge true potential"] = 2600,
    ["trollge true potential's:funny"] = 2600,
    ["trollge true potential's:emperor of war"] = 2600,
    ["decayed reaper"] = 2400,
    ["omega booster"] = 2150,
    ["true reaper essence"] = 1650,
    ["reaper"] = 1550,
    ["ultra booster"] = 1500,
    ["trollge: suppressed potential"] = 1450,
    ["trollge suppressed potential"] = 1450,
    ["dancer"] = 1450,
    ["golden feddy"] = 1100,
    ["feddy"] = 1029,

    -- S Tier
    ["kindness"] = 875,
    ["trollge:mlg"] = 780,
    ["trollge mlg"] = 780,
    ["meme cup"] = 770,
    ["lord of darkness"] = 750,
    ["meme troll:???"] = 685,
    ["meme troll:evil"] = 675,
    ["meme troll evil"] = 675,
    ["meme troll"] = 675,
    ["cursed arrow"] = 660,
    ["tanglecleaver"] = 615,
    ["shadow blade"] = 600,
    ["phantom feddy"] = 600,
    ["valentines chest"] = 600,
    ["the tiantui star"] = 575,
    ["the voices"] = 545,
    ["hollow trolling:suppressed"] = 520,
    ["hollow trolling suppressed"] = 520,
    ["prince of blood"] = 500,
    ["the roaring knight"] = 500,
    ["omnipotent"] = 450,
    ["booster"] = 400,
    ["halloween cup"] = 400,
    ["paint brush"] = 350,
    ["easter painter"] = 300,
    ["mountain dew"] = 300,
    ["eyes of desire"] = 270,
    ["wicked chest"] = 260,
    ["holiday chest"] = 260,
    ["lance of dream"] = 250,
    ["mysterious spellbook"] = 225,

    -- A Tier
    ["viridian witch"] = 200,
    ["jordan shoes"] = 200,
    ["omniversal energy cube"] = 200,
    ["halloween crate"] = 190,
    ["troll the awesome"] = 180,
    ["troll yourself"] = 175,
    ["sansta"] = 175,
    ["g@ster's soul"] = 175,
    ["g@ster’s soul"] = 175,
    ["ruler:budget"] = 170,
    ["devourer of omniversal"] = 170,
    ["taller guy"] = 170,
    ["magic staff"] = 170,
    ["easter cup"] = 160,
    ["glitched vhs tape"] = 160,
    ["the tiantui star fragment"] = 160,
    ["fear"] = 160,
    ["halloween hell"] = 160,
    ["halloween trickster"] = 160,
    ["sussy baka"] = 155,
    ["easter mascot"] = 150,
    ["frostbite"] = 150,
    ["spring trap"] = 150,
    ["lonely cup"] = 145,
    ["shadow crystal"] = 140,
    ["troll:debug:malware"] = 130,
    ["troll:debug:bsod"] = 130,
    ["troll:debug"] = 125,
    ["blood grail"] = 125,
    ["black shard"] = 120,
    ["w.d gaster"] = 115,
    ["vhs sans"] = 115,
    ["lightened cup"] = 105,
    ["golden egg"] = 100,
    ["part"] = 100,
    ["omniversal cup"] = 100,
    ["maniac's power"] = 100,
    ["maniac’s power"] = 100,
    ["painting"] = 100,
    ["easter priest"] = 100,
    ["chara"] = 100,
    ["omniversal chest"] = 100,
    ["valentines shard"] = 100,
    ["easter warrior"] = 95,
    ["lonely one"] = 90,
    ["pumpking"] = 90,
    ["necromancer"] = 90,
    ["pain cup"] = 90,
    ["cold crusader"] = 85,
    ["frost spirit"] = 85,
    ["valentines angel"] = 80,
    ["valentines protector"] = 80,
    ["corrupted fragment"] = 80,
    ["gambler"] = 80,
    ["light warrior"] = 80,
    ["trollge.exe:vanity"] = 80,
    ["trollge.exe:sonic"] = 80,
    ["trollge.exe"] = 80,
    ["embodiment of hatred"] = 80,
    ["killer fish"] = 80,
    ["trollge.exe:horrortale"] = 75,
    ["broke crown"] = 75,
    ["nightmare hatred"] = 75,
    ["love harvester"] = 75,
    ["jolly troll"] = 75,
    ["krampus"] = 75,
    ["skin cup"] = 70,
    ["determination soul"] = 70,
    ["core of the void"] = 70,
    ["the manic troll"] = 70,
    ["nightmare shard"] = 70,
    ["stabilized energy compound"] = 70,
    ["infinite galactic cup"] = 65,
    ["ruler: guardian of the galaxy"] = 60,
    ["grinch"] = 60,
    ["yeti"] = 60,

    -- B Tier & Under
    ["jolly teleporter"] = 50,
    ["vhs tapes"] = 50,
    ["sorcerers:outer"] = 50,
    ["energy power source"] = 45,
    ["sorcerers"] = 45,
    ["santa"] = 45,
    ["elf"] = 45,
    ["blueprint #1"] = 40,
    ["neon shard"] = 40,
    ["soul incident"] = 40,
    ["ruler energy"] = 35,
    ["multiversal god"] = 35,
    ["multiversal nightmare"] = 35,
    ["the sinner one"] = 35,
    ["upgraded machine"] = 35,
    ["hopes and dreams"] = 30,
    ["omniversal dev"] = 30,
    ["bad trolling:lagtrain"] = 30,
    ["bad trolling:youmu"] = 30,
    ["lbs:rejuvenation"] = 25,
    ["lbs:green"] = 25,
    ["nightmare orb"] = 25,
    ["ruller of night"] = 25,
    ["new friends"] = 25,
    ["energy shard"] = 25,
    ["present"] = 25,
    ["tigermark bullet"] = 20,
    ["crazed troll"] = 20,
    ["last breath sans"] = 20,
    ["hardmode sans"] = 20,
    ["bone"] = 20,
    ["happiness"] = 20,
    ["ut shard"] = 20,
    ["king shard"] = 20,
    ["metal"] = 20,
    ["jeff the killer:chad"] = 18,
    ["sans:pacifist:ao no sumika"] = 17,
    ["anti ruler"] = 16,
    ["ruler chest"] = 15,
    ["bad trolling"] = 15,
    ["mech troll"] = 15,
    ["trollge core"] = 10,
    ["purple guy"] = 10,
    ["glitch troll"] = 10,
    ["ruler:tm"] = 10,
    ["ruler"] = 5,
    ["slenderman"] = 3,
}

-- Cache kết quả đã tính để tránh lặp lại thuật toán xử lý chuỗi
local ValueCache = {}

local function formatNumber(n)
    local formatted = tostring(n)
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function cleanString(str)
    if not str then return "" end
    local clean = string.lower(str)
    clean = string.gsub(clean, "[%[%]%_%>%<%>%:%'%>%\"%@%#%$%*%~%`%-]", " ")
    clean = string.gsub(clean, "%s+", " ")
    return string.gsub(clean, "^%s*(.-)%s*$", "%1")
end

local function levenshtein(s1, s2)
    local len1, len2 = #s1, #s2
    if len1 == 0 then return len2 end
    if len2 == 0 then return len1 end
    local matrix = {}
    for i = 0, len1 do matrix[i] = {[0] = i} end
    for j = 0, len2 do matrix[0][j] = j end
    for i = 1, len1 do
        local b1 = string.byte(s1, i)
        for j = 1, len2 do
            local b2 = string.byte(s2, j)
            local cost = (b1 == b2) and 0 or 1
            matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
        end
    end
    return matrix[len1][len2]
end

local function getItemValue(item)
    if ValueCache[item] then return ValueCache[item] end

    local namesToTest = { item.Name }
    if item:IsA("TextLabel") or item:IsA("TextButton") then
        table.insert(namesToTest, item.Text)
    end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("StringValue") then
            table.insert(namesToTest, child.Value)
        elseif child:IsA("TextLabel") or child:IsA("TextButton") then
            table.insert(namesToTest, child.Text)
        end
    end

    local cleanedNames = {}
    for _, rawName in ipairs(namesToTest) do
        local cName = cleanString(rawName)
        if cName ~= "" then table.insert(cleanedNames, cName) end
    end

    -- Exact match
    for _, cName in ipairs(cleanedNames) do
        if ValueTable[cName] then
            ValueCache[item] = ValueTable[cName]
            return ValueTable[cName]
        end
    end

    -- Substring match
    for _, cName in ipairs(cleanedNames) do
        for nameInTable, val in pairs(ValueTable) do
            if string.find(cName, nameInTable, 1, true) or string.find(nameInTable, cName, 1, true) then
                local lenRatio = #cName / #nameInTable
                if lenRatio >= 0.65 and lenRatio <= 1.35 then
                    ValueCache[item] = val
                    return val
                end
            end
        end
    end

    -- Fuzzy Match (Levenshtein)
    local bestMatchVal = 0
    local highestSimilarity = 0
    for _, cName in ipairs(cleanedNames) do
        for nameInTable, val in pairs(ValueTable) do
            local maxLen = math.max(#cName, #nameInTable)
            if maxLen > 0 then
                local sim = 1 - (levenshtein(cName, nameInTable) / maxLen)
                if sim > highestSimilarity and sim >= 0.72 then
                    highestSimilarity = sim
                    bestMatchVal = val
                end
            end
        end
    end

    ValueCache[item] = bestMatchVal
    return bestMatchVal
end

local function calculateTotalValue(container)
    if not container then return 0 end
    local totalVal = 0
    for _, child in ipairs(container:GetChildren()) do
        if not child:IsA("UIComponent") and not child:IsA("UIGridLayout") and not child:IsA("UIListLayout") then
            totalVal = totalVal + getItemValue(child)
        end
    end
    return totalVal
end

-- ==========================================
-- GIAO DIỆN UI (REAPERHUB THEME)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false

pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 24)
toggleBtn.Position = UDim2.new(1, -170, 0, -20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
toggleBtn.Text = "ON"
toggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Thickness = 1.2
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnStroke.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 90)
mainFrame.Position = UDim2.new(1, -170, 0, 8)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local function createCell(pos, size, text, isHeader)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = pos
    label.BackgroundColor3 = isHeader and Color3.fromRGB(25, 25, 25) or Color3.fromRGB(22, 22, 22)
    label.BackgroundTransparency = isHeader and 0 or 0.2
    label.Text = text
    label.TextColor3 = isHeader and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 255, 255)
    label.Font = isHeader and Enum.Font.GothamBold or Enum.Font.GothamMedium
    label.TextSize = isHeader and 13 or 14
    label.Parent = mainFrame

    local cellCorner = Instance.new("UICorner")
    cellCorner.CornerRadius = UDim.new(0, 4)
    cellCorner.Parent = label

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = label

    return label
end

createCell(UDim2.new(0.04, 0, 0.06, 0), UDim2.new(0.44, 0, 0.32, 0), "you", true)
createCell(UDim2.new(0.52, 0, 0.06, 0), UDim2.new(0.44, 0, 0.32, 0), "other", true)

local youValue = createCell(UDim2.new(0.04, 0, 0.42, 0), UDim2.new(0.44, 0, 0.52, 0), "Nothing", false)
local otherValue = createCell(UDim2.new(0.52, 0, 0.42, 0), UDim2.new(0.44, 0, 0.52, 0), "Nothing", false)

local isVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    mainFrame.Visible = isVisible
    toggleBtn.Text = isVisible and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = isVisible and Color3.fromRGB(28, 28, 28) or Color3.fromRGB(45, 45, 45)
end)

-- ==========================================
-- CẬP NHẬT TỐI ƯU SIÊU MƯỢT (EVENT-BASED)
-- ==========================================
local activeConnections = {}

local function clearConnections()
    for _, conn in ipairs(activeConnections) do
        conn:Disconnect()
    end
    table.clear(activeConnections)
end

local function updateTradeValues(myOffer, tOffer)
    local myTotalVal = calculateTotalValue(myOffer)
    local tTotalVal = calculateTotalValue(tOffer)

    youValue.Text = formatNumber(myTotalVal)
    otherValue.Text = formatNumber(tTotalVal)

    if myTotalVal == 0 then
        youValue.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        local ratio = tTotalVal / myTotalVal
        if ratio >= 1 then
            youValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif ratio >= 0.75 then
            youValue.TextColor3 = Color3.fromRGB(255, 255, 0)
        elseif ratio >= 0.50 then
            youValue.TextColor3 = Color3.fromRGB(255, 140, 0)
        else
            youValue.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

-- Vòng lặp nhẹ kiểm tra khi mở/đóng cửa sổ Trade
task.spawn(function()
    local lastState = false
    while task.wait(0.5) do
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local trade = playerGui and playerGui:FindFirstChild("Trade")
            local trader = trade and trade:FindFirstChild("Trader")

            if trader and trader.Visible then
                if not lastState then
                    lastState = true
                    table.clear(ValueCache) -- Làm sạch cache cho phiên trade mới
                    clearConnections()

                    local myOffer = trader:FindFirstChild("MyOffer")
                    local tOffer = trader:FindFirstChild("TOffer")

                    local function onTradeChanged()
                        updateTradeValues(myOffer, tOffer)
                    end

                    if myOffer then
                        table.insert(activeConnections, myOffer.ChildAdded:Connect(onTradeChanged))
                        table.insert(activeConnections, myOffer.ChildRemoved:Connect(onTradeChanged))
                    end
                    if tOffer then
                        table.insert(activeConnections, tOffer.ChildAdded:Connect(onTradeChanged))
                        table.insert(activeConnections, tOffer.ChildRemoved:Connect(onTradeChanged))
                    end

                    updateTradeValues(myOffer, tOffer)
                end
            else
                if lastState then
                    lastState = false
                    clearConnections()
                    youValue.Text = "Nothing"
                    otherValue.Text = "Nothing"
                    youValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                    otherValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end)
    end
end)
