local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Список петов
local targetPets = {
    "Chimpanzini Spiderini",
    "Karkerkar Kurkur",
    "Los Matteos",
    "La Vacca Saturno Saturnita",
    "Agarini la Palini",
    "Dragon Cannelloni",
    "Garama and Madundung",
    "Los Hotspot",
    "Nuclearo Dinossauro",
    "Los Combinasionas",
    "La Grande Combinasion",
    "Chicleteira Bicicleteira",
    "Esok Sekolah",
    "Torrtuginni Dragonfrutini",
    "Pot Hotspo",
    "Nooo My Hotspot",
    "Graipus Medussi",
    "job job job Sahur",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Sammyni Spyderini"
}

-- Проверка наличия пета
local function hasPet()
    local function checkIn(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if table.find(targetPets, child.Name) then
                return true
            end
        end
        return false
    end

    if checkIn(player.Backpack) then return true end
    if player.Character and checkIn(player.Character) then return true end
    if checkIn(workspace) then return true end
    return false
end

-- Телепортация на новый сервер
local function teleportToNewServer()
    local placeId = 109983668079237 -- ID игры
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullServers=true", placeId)

    local success, response = pcall(function()
        return HttpService:GetAsync(url, {
            Headers = {
                ["User-Agent"] = "Mozilla/5.0"
            }
        })
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
        local serverId = server.id
        local teleportSuccess, teleportErr = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, serverId)
        end)

        if teleportSuccess then
            print("Телепортация успешна!")
            return
        else
            warn("Ошибка телепортации:", teleportErr)
        end
    end
end

-- Основной цикл
while true do
    if hasPet() then
        print("Обнаружен целевой пета! Поиск нового сервера...")
        teleportToNewServer()
    end
    wait(5)
end
