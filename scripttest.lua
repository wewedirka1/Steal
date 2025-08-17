-- ================================================================================= --
--                             СКРИПТ ДЛЯ ЗАХОДА НА ПЕРВЫЙ СЕРВЕР (ИСПРАВЛЕННЫЙ)         --
--                                  Игра: Steal a brainrot                          --
-- ================================================================================= --

-- // ============================= [ НАСТРОЙКИ ] ============================= //

-- Place ID — для телепорта
local PLACE_ID = 17094244510

-- Universe ID — для получения списка серверов
local UNIVERSE_ID = 5891316523

-- Функция HTTP-запроса — выберите под свой инжектор
local requestFunction = request -- Для Krnl, Fluxus, Script-Ware
--[[
local requestFunction = syn.request -- Для Synapse X
]]

-- Ссылка для получения списка серверов
local SERVER_LIST_URL = string.format(
    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullServers=true",
    UNIVERSE_ID
)

-- // ============================ [ ЛОГИКА СКРИПТА ] ============================ //

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    print(string.format("[AutoJoin] %s: %s", title, text))
    pcall(function()
        game.StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = 5 })
    end)
end

local function joinFirstServer()
    notify("Подключение", "Получаю список серверов...")

    local success, response = pcall(function()
        return requestFunction({
            Url = SERVER_LIST_URL,
            Method = "GET"
        })
    end)

    if not success or not response then
        notify("Ошибка", "Не удалось получить список серверов. Проверьте интернет или настройки инжектора.")
        return
    end

    if response.StatusCode ~= 200 then
        notify("Ошибка", "Сервер Roblox вернул ошибку: " .. response.StatusMessage)
        return
    end

    local serverData = HttpService:JSONDecode(response.Body)
    local servers = serverData.data

    if not servers or #servers == 0 then
        notify("Ошибка", "Нет доступных серверов. Попробуйте позже.")
        return
    end

    local firstServer = servers[1]
    local jobId = firstServer.id
    local playerCount = firstServer.playing

    notify("Успех", string.format("Найден сервер: %d игроков. Телепортируюсь...", playerCount))

    pcall(function()
        TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, LocalPlayer)
    end)
end

task.wait(5)
joinFirstServer()
