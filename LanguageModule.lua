local CoreGui = game:GetService("CoreGui")
local gui = CoreGui:FindFirstChild("ReaperHub_GUI")

if not gui then return end

-- Chuyển đổi trạng thái ngôn ngữ
_G.ReaperHubLanguage = (_G.ReaperHubLanguage == "Tiếng Việt") and "English" or "Tiếng Việt"
local currentLang = _G.ReaperHubLanguage

-- Bảng từ điển dịch thuật
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
    ["Tools"] = "Công cụ",
    ["Options"] = "Tùy chọn",
    ["Ping stat"] = "Bảng Ping",
    ["Server time"] = "Thời gian Server",
    ["Chest stat"] = "Thống kê Rương",
    ["ESP Chest"] = "ESP Rương",
    ["ESP Boss"] = "ESP Boss",
    ["Fullbright"] = "Độ sáng tối đa",
    ["Remove Fog"] = "Xóa sương mù",
    ["Items Finder"] = "Tìm vật phẩm",
    ["Trading value"] = "Bảng giá Trade",
    ["Save config"] = "Lưu cấu hình",
    ["Language"] = "Ngôn ngữ"
}

-- Hàm đảo ngược từ điển khi chuyển lại về Tiếng Anh
local ReverseDict = {}
for en, vi in pairs(Dictionary) do
    ReverseDict[vi] = en
end

-- Quét toàn bộ TextLabel / TextButton trong GUI để đổi chữ
for _, obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        if currentLang == "Tiếng Việt" then
            if Dictionary[obj.Text] then
                obj.Text = Dictionary[obj.Text]
            end
        else
            if ReverseDict[obj.Text] then
                obj.Text = ReverseDict[obj.Text]
            end
        end
    end
end

print("[ReaperHub] Language changed to: " .. currentLang)
