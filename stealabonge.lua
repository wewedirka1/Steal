local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Получаем локального игрока
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeGui"
screenGui.Parent = StarterGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0.5, -50, 0.5, -25)
toggleButton.Text = "God Mode: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = frame

-- Переменная для отслеживания режима неуязвимости
local godMode = false

-- Функция для переключения режима неуязвимости
local function toggleGodMode()
    godMode = not godMode
    toggleButton.Text = godMode and "God Mode: ON" or "God Mode: OFF"
    
    if godMode then
        -- Устанавливаем максимальное здоровье и предотвращаем урон
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

-- Обработка нажатия клавиши F1
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.F1 then
        toggleGodMode()
    end
end)

-- Обработка нажатия кнопки
toggleButton.MouseButton1Click:Connect(toggleGodMode)

-- Обновление персонажа при респауне
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)
