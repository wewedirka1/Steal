local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Телепортация на рандомный сервер
local function teleportToRandomServer()
    local placeId = 109983668079237 -- ID игры

    local servers = {}
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullServers=true", placeId)

    local success, response = pcall(function()
        local request = HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
            }
        })
        return request.Success, request.Body
    end)

    if not success then
        warn("Ошибка получения серверов:", response)
        return
    end

    local data = HttpService:JSONDecode(response)
    if not data or not data.data then
        warn("Неверный формат ответа")
        return
    end

    for _, server in ipairs(data.data) do
        table.insert(servers, server.id)
    end

    if #servers == 0 then
        warn("Нет доступных серверов")
        return
    end

    local randomServerId = servers[math.random(1, #servers)]
    local teleportSuccess, teleportErr = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, randomServerId)
    end)

    if teleportSuccess then
        print("Телепортация успешна!")
    else
        warn("Ошибка телепортации:", teleportErr)
    end
end

-- Основной цикл
while true do
    teleportToRandomServer()
    wait(10)
end
