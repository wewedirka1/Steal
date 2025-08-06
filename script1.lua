local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Ждем, пока появится персонаж
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- Создаем GUI (автоматически при заходе в игру)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0.9, -25) -- Внизу экрана
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0.8, 0)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Телепорт вперед (F)"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.Parent = frame

-- Настройки телепортации
local TELEPORT_DISTANCE = 10
local TELEPORT_COOLDOWN = 1
local canTeleport = true

local function teleportForward()
    if not canTeleport or not character:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    canTeleport = false
    
    local rootPart = character.HumanoidRootPart
    local lookVector = rootPart.CFrame.LookVector
    local newPosition = rootPart.Position + (lookVector * TELEPORT_DISTANCE)
    
    -- Фикс: чтобы не улететь под карту
    if newPosition.Y < 0 then
        newPosition = Vector3.new(newPosition.X, 5, newPosition.Z)
    end
    
    -- Телепортация
    rootPart.CFrame = CFrame.new(newPosition)
    
    -- Эффект телепортации (исчезающий блок)
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(2, 2, 2)
    effect.Position = rootPart.Position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Transparency = 0.7
    effect.Material = Enum.Material.Neon
    effect.Color = Color3.fromRGB(0, 170, 255)
    effect.Parent = workspace
    game.Debris:AddItem(effect, 0.5)
    
    
    -- Кулдаун
    task.wait(TELEPORT_COOLDOWN)
    canTeleport = true
end

-- Кнопка работает
button.MouseButton1Click:Connect(teleportForward)

-- Клавиша F тоже работает
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        teleportForward()
    end
end)
