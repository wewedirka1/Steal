-- ================================================================================= --
--                             СКРИПТ ДЛЯ ТЕЛЕПОРТА НА РАНДОМНЫЙ СЕРВЕР               --
--                                  Игра: Steal a brainrot                          --
-- ================================================================================= --

-- // ============================= [ НАСТРОЙКИ ] ============================= //

-- Place ID — для телепорта (не трогать)
local PLACE_ID = 17094244510

-- Universe ID — для получения списка серверов (не трогать)
local UNIVERSE_ID = 5891316523

-- ВАЖНО! Выберите функцию под ваш инжектор:
-- Удалите комментарии (--[[ ... ]]) перед нужной строкой

local requestFunction = request -- Для Krnl, Fluxus, Script-Ware
--[[
local requestFunction = syn.request -- Для Synapse X
]]

-- // ============================ [ ЛОГИКА СКРИПТА ] ============================ //

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    print(string.format("[RandomJoin] %s: %s", title, text))
    pcall(function()
        game.StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = 5 })
    end)
end

local function joinRandomServer()
    notify("Подключение", "Получаю список серверов...")

    local success, response = pcall(function()
        return requestFunction({
            Url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullServers=true",
                UNIVERSE_ID
            ),
            Method = "GET"
        })
    end)

    if not success or not response then
        notify("Ошибка", "Не удалось получить список серверов.")
        return
    end

    if response.StatusCode ~= 200 then
        notify("Ошибка", "Сервер Roblox вернул ошибку: " .. response.StatusMessage)
        return
    end

    local serverData = HttpService:JSONDecode(response.Body)
    local servers = serverData.data

    if not servers or #servers == 0 then
        notify("Ошибка", "Нет доступных серверов.")
        return
    end

    -- Выбираем случайный сервер из списка
    local randomIndex = math.random(1, #servers)
    local randomServer = servers[randomIndex]
    local jobId = randomServer.id
    local playerCount = randomServer.playing

    notify("Успех", string.format("Выбран сервер с %d игроками. Телепортируюсь...", playerCount))

    pcall(function()
        TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, LocalPlayer)
    end)
end

-- Запускаем через 5 секунд после загрузки
task.wait(5)
joinRandomServer()
