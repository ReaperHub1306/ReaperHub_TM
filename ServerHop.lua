-- ==========================================
-- REAPERHUB: SERVER HOP MODULE (SMALL SERVER)
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId
local JobId = game.JobId

print("[ReaperHub] Searching for a smaller server...")

local function HopToSmallServer()
    local success, result = pcall(function()
        -- Lấy danh sách Server từ Roblox API
        local rawData = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/0?sortOrder=Asc&limit=100")
        return HttpService:JSONEncode(HttpService:JSONDecode(rawData))
    end)

    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data.data then
            for _, server in ipairs(data.data) do
                -- Chọn server khác server hiện tại và còn trống chỗ
                if server.id ~= JobId and server.playing < server.maxPlayers then
                    print("[ReaperHub] Found server: " .. server.id .. " (" .. server.playing .. "/" .. server.maxPlayers .. " players)")
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
                    return
                end
            end
        end
    end
    print("[ReaperHub] Couldn't find a suitable server, retrying...")
end

HopToSmallServer()
