local CoreGui = game:GetService("CoreGui")
local gui = CoreGui:FindFirstChild("ReaperHub_GUI")
if not gui then return end

local currentLang = _G.ReaperHubConfig and _G.ReaperHubConfig.Language or "English"

local Dictionary = {
    ["Main"] = "Chính",
    ["visual"] = "Hình ảnh",
    ["Cilent"] = "Hệ thống",
    ["pvp"] = "Chiến đấu",
    ["trading"] = "Giao dịch",
    ["setting"] = "Cài đặt",
    ["Information"] = "Thông tin",
    ["Stats"] = "Chỉ số",
    ["ESP"] = "Hiển thị ESP",
    ["Environment"] = "Môi trường",
    ["Utilities"] = "Tiện ích",
    ["Tools"] = "Công cụ",
    ["Options"] = "Tùy chọn",
    ["Ping stat"] = "Bảng Ping",
    ["Server time"] = "Thời gian Server",
    ["Chest stat"] = "Thống kê Rương",
    ["ESP Chest"] = "ESP Rương",
    ["ESP Boss"] = "ESP Boss",
    ["Fullbright"] = "Độ sáng tối đa",
    ["Remove Fog"] = "Xóa sương mù",
    ["Anti-AFK"] = "Chống AFK",
    ["Server Hop"] = "Đổi Server",
    ["Items Finder"] = "Tìm vật phẩm",
    ["Trading value"] = "Bảng giá Trade",
    ["Save config"] = "Lưu cấu hình"
}

local ReverseDict = {}
for en, vi in pairs(Dictionary) do
    ReverseDict[vi] = en
end

for _, obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        local text = obj.Text
        if currentLang == "Tiếng Việt" then
            if Dictionary[text] then obj.Text = Dictionary[text] end
        else
            if ReverseDict[text] then obj.Text = ReverseDict[text] end
        end
    end
end
