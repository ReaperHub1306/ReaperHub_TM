local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- XỬ LÝ BẬT/TẮT NÚT (TRÁNH TRÙNG LẶP UI)
-- ==========================================
local guiName = "TradeTrackerGUI"

if getgenv().ReaperHub_TradeTracker_Loaded then
    local existingGui = CoreGui:FindFirstChild(guiName) or LocalPlayer.PlayerGui:FindFirstChild(guiName)
    if existingGui then
        existingGui.Enabled = not existingGui.Enabled
    end
    return
end

getgenv().ReaperHub_TradeTracker_Loaded = true

-- 1. Tự động xóa bản cũ nếu đã tồn tại
if CoreGui:FindFirstChild(guiName) then
    CoreGui:FindFirstChild(guiName):Destroy()
end
if LocalPlayer.PlayerGui:FindFirstChild(guiName) then
    LocalPlayer.PlayerGui:FindFirstChild(guiName):Destroy()
end

-- 2. Bảng Giá Trị (Value Table)
local ValueTable = {
    -- SS+ Tier
    ["bob cup"] = 70000,
    ["source of all creation"] = 50000,
    ["soac"] = 50000,
    ["rob cup"] = 38000,
    ["rob"] = 25000,
    ["equinox:evil"] = 16000,
    ["equinox evil"] = 16000,
    ["equinox"] = 16000,
    ["sunglasses"] = 12000,

    -- SS Tier
    ["reaper essence"] = 8500,
    ["true ruler spirit"] = 6250,
    ["bob"] = 5500,
    ["hollow trolling"] = 4250,
    ["omega booster"] = 3200,
    ["halloween chest"] = 3000,
    ["kindness soul"] = 2700,
    ["trollge:true potential"] = 2600,
    ["trollge true potential"] = 2600,
    ["decayed reaper"] = 2400,
    ["true reaper essence"] = 1650,
    ["reaper"] = 1550,
    ["trollge: suppressed potential"] = 1450,
    ["trollge suppressed potential"] = 1450,
    ["ultra booster"] = 1450,
    ["dancer"] = 1450,
    ["golden feddy"] = 1100,
    ["feddy"] = 1029,
    ["lord of darkness"] = 1010,

    -- S Tier
    ["kindness"] = 875,
    ["trollge:mlg"] = 780,
    ["trollge mlg"] = 780,
    ["meme cup"] = 770,
    ["hollow trolling:suppressed"] = 750,
    ["hollow trolling suppressed"] = 750,
    ["tanglecleaver"] = 735,
    ["shadow blade"] = 720,
    ["cursed arrow"] = 700,
    ["the tiantui star"] = 685,
    ["meme troll"] = 675,
    ["the roaring knight"] = 650,
    ["the voices"] = 650,
    ["omnipotent"] = 625,
    ["phantom feddy"] = 600,
    ["valentines chest"] = 600,
    ["prince of the blood"] = 500,
    ["booster"] = 400,
    ["halloween cup"] = 400,
    ["paint brush"] = 350,
    ["easter painter"] = 300,
    ["mountain dew"] = 300,
    ["omniversal energy cube"] = 280,
    ["the tiantui star fragment"] = 280,
    ["eyes of desire"] = 270,
    ["wicked chest"] = 260,
    ["holiday chest"] = 260,
    ["lance of dream"] = 250,
    ["mysterious spellbook"] = 225,

    -- A Tier
    ["fear"] = 200,
    ["halloween hell"] = 200,
    ["viridian witch"] = 200,
    ["jordan shoes"] = 200,
    ["halloween crate"] = 190,
    ["easter mascot"] = 185,
    ["troll the awesome"] = 180,
    ["troll yourself"] = 175,
    ["sansta"] = 175,
    ["g@ster's soul"] = 175,
    ["g@ster’s soul"] = 175,
    ["magic staff"] = 170,
    ["easter cup"] = 160,
    ["shadow crystal"] = 160,
    ["glitched vhs tape"] = 160,
    ["sussy baka"] = 155,
    ["black shard"] = 150,
    ["easter priest"] = 150,
    ["frostbite"] = 150,
    ["spring trap"] = 150,
    ["lonely cup"] = 145,
    ["grinch"] = 145,
    ["debug"] = 130,
    ["lonely one"] = 130,
    ["santa"] = 130,
    ["cold crusader"] = 130,
    ["frost spirit"] = 130,
    ["halloween trickster"] = 130,
    ["elf"] = 130,
    ["troll:debug"] = 125,
    ["troll debug"] = 125,
    ["blood grail"] = 125,
    ["pumpking"] = 125,
    ["easter warrior"] = 120,
    ["w.d gaster"] = 115,
    ["ruler:budget"] = 115,
    ["devourer of omniversal"] = 115,
    ["vhs sans"] = 115,
    ["krampus"] = 115,
    ["necromancer"] = 110,
    ["lightened cup"] = 105,
    ["jolly troll"] = 105,
    ["golden egg"] = 100,
    ["part"] = 100,
    ["tigermark bullet"] = 100,
    ["omniversal cup"] = 100,
    ["maniac's power"] = 100,
    ["maniac’s power"] = 100,
    ["painting"] = 100,
    ["valentines protector"] = 100,
    ["chara"] = 100,
    ["omniversal chest"] = 100,
    ["yeti"] = 100,
    ["valentines shard"] = 100,
    ["valentines angel"] = 100,
    ["pain cup"] = 90,
    ["trollge.exe:vanity"] = 85,
    ["corrupted fragment"] = 80,
    ["gambler"] = 80,
    ["lightened warrior"] = 80,
    ["trollge.exe"] = 80,
    ["embodiment of hatred"] = 80,
    ["trollge.exe:sonic"] = 80,
    ["killer fish"] = 80,
    ["taller guy"] = 80,
    ["trollge.exe:horrortale"] = 75,
    ["neon shard"] = 75,
    ["broke crown"] = 75,
    ["ruler energy"] = 75,
    ["nightmare hatred"] = 75,
    ["bad trolling"] = 75,
    ["love harvester"] = 75,
    ["skin cup"] = 70,
    ["core of the void"] = 70,
    ["the manic troll"] = 70,
    ["stabilized energy compound"] = 70,
    ["infinite galactic cup"] = 65,
    ["ruler: guardian of the galaxy"] = 60,
    ["metal"] = 60,

    -- B Tier & Under
    ["jolly teleporter"] = 50,
    ["vhs tapes"] = 50,
    ["sorcerers:outer"] = 50,
    ["energy power source"] = 45,
    ["sorcerers"] = 45,
    ["blueprint #1"] = 40,
    ["soul incident"] = 40,
    ["multiversal god"] = 35,
    ["multiversal nightmare"] = 35,
    ["the sinner one"] = 35,
    ["upgraded machine"] = 35,
    ["omniversal dev"] = 30,
    ["nightmare shard"] = 30,
    ["lbs:rejuvenation"] = 25,
    ["lbs:green"] = 25,
    ["determination soul"] = 25,
    ["nightmare orb"] = 25,
    ["ruler of night"] = 25,
    ["new friends"] = 25,
    ["hopes and dreams"] = 25,
    ["energy shard"] = 25,
    ["present"] = 25,
    ["crazed troll"] = 20,
    ["last breath sans"] = 20,
    ["hardmode sans"] = 20,
    ["bone"] = 20,
    ["happiness"] = 20,
    ["ut shard"] = 20,
    ["king shard"] = 20,
    ["jeff the killer:chad"] = 18,
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

-- 3. Hàm định dạng số có dấu phẩy
local function formatNumber(n)
    local formatted = tostring(n)
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- 4. Thuật toán làm sạch tên và So sánh độ tương đồng (Fuzzy Matching)
local function cleanString(str)
    if not str then return "" end
    local clean = string.lower(str)
    clean = string.gsub(clean, "[%[%]%_%>%<%>%:%'%>%\"%@%#%$%*%~%`%-]", " ")
    clean = string.gsub(clean, "%s+", " ")
    clean = string.gsub(clean, "^%s*(.-)%s*$", "%1")
    return clean
end

local function levenshtein(s1, s2)
    local len1, len2 = #s1, #s2
    if len1 == 0 then return len2 end
    if len2 == 0 then return len1 end

    local matrix = {}
    for i = 0, len1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    for i = 1, len1 do
        local b1 = string.byte(s1, i)
        for j = 1, len2 do
            local b2 = string.byte(s2, j)
            local cost = (b1 == b2) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )
        end
    end
    return matrix[len1][len2]
end

local function getSimilarity(s1, s2)
    local maxLen = math.max(#s1, #s2)
    if maxLen == 0 then return 1 end
    local dist = levenshtein(s1, s2)
    return 1 - (dist / maxLen)
end

-- 5. Hàm lấy Value thông minh (Multi-Stage Search)
local function getItemValue(item)
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
        if cName ~= "" then
            table.insert(cleanedNames, cName)
        end
    end

    for _, cName in ipairs(cleanedNames) do
        if ValueTable[cName] then
            return ValueTable[cName]
        end
    end

    for _, cName in ipairs(cleanedNames) do
        for nameInTable, val in pairs(ValueTable) do
            if string.find(cName, nameInTable, 1, true) or string.find(nameInTable, cName, 1, true) then
                local lenRatio = #cName / #nameInTable
                if lenRatio >= 0.65 and lenRatio <= 1.35 then
                    return val
                end
            end
        end
    end

    local bestMatchVal = 0
    local highestSimilarity = 0
    local MIN_SIMILARITY = 0.72

    for _, cName in ipairs(cleanedNames) do
        for nameInTable, val in pairs(ValueTable) do
            local similarity = getSimilarity(cName, nameInTable)
            if similarity > highestSimilarity and similarity >= MIN_SIMILARITY then
                highestSimilarity = similarity
                bestMatchVal = val
            end
        end
    end

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

-- 6. Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung UI chính (ReaperHub Theme)
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

-- 7. Cập nhật liên tục & So sánh tỷ lệ
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local trade = playerGui and playerGui:FindFirstChild("Trade")
            local trader = trade and trade:FindFirstChild("Trader")

            if trader and trader.Visible then
                local myOffer = trader:FindFirstChild("MyOffer")
                local tOffer = trader:FindFirstChild("TOffer")

                local myTotalVal = calculateTotalValue(myOffer)
                local tTotalVal = calculateTotalValue(tOffer)

                youValue.Text = formatNumber(myTotalVal)
                otherValue.Text = formatNumber(tTotalVal)
                otherValue.TextColor3 = Color3.fromRGB(255, 255, 255)

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
            else
                youValue.Text = "Nothing"
                otherValue.Text = "Nothing"
                youValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                otherValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
    end
end)
