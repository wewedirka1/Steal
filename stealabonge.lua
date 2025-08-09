local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Получаем локального игрока
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Создаем GUI, оптимизированное для мобильных устройств
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeGui"
screenGui.Parent = StarterGui
screenGui.ResetOnSpawn = false -- GUI не сбрасывается при респауне

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 80) -- Большой размер для удобства на телефоне
frame.Position = UDim2.new(0.5, -75, 0.8, -40) -- Внизу экрана для удобного нажатия
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -10, 1, -10) -- Заполняет рамку с небольшим отступом
toggleButton.Position = UDim2.new(0, 5, 0, 5)
toggleButton.Text = "God Mode: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true -- Текст адаптируется к размеру кнопки
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = frame

-- Переменная для отслеживания режима неуязвимости
local godMode = false

-- Функция для переключения режима неуязвимости
local function toggleGodMode()
    godMode = not godMode
    toggleButton.Text = godMode and "God Mode: ON" or "God Mode: OFF"
    toggleButton.BackgroundColor3 = godMode and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 255)
    
    if godMode then
        -- Устанавливаем бесконечное здоровье
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    else
        -- Возвращаем нормальное здоровье
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

-- Обработка изменения здоровья
humanoid.HealthChanged:Connect(function(health)
    if godMode and health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth -- Восстанавливаем здоровье при уроне
    end
end)

-- Обработка нажатия кнопки
toggleButton.Activated:Connect(toggleGodMode) -- Используем Activated для совместимости с сенсорными экранами

-- Обновление персонажа при респауне
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)
