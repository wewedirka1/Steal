-- Красивый GUI скрипт для Roblox
-- Функции: Noclip, Walkspeed, ESP, поддержка телефонов

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Проверка на мобильное устройство
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Переменные для функций
local noclipEnabled = false
local espEnabled = false
local currentWalkspeed = 16
local espObjects = {}

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeautifulHackGUI"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.ClipsDescendants = true

-- Градиентная рамка
local gradient = Instance.new("UIGradient")
gradient.Parent = mainFrame
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 255, 0))
})
gradient.Rotation = 45

-- Анимация градиента
local gradientTween = TweenService:Create(gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 405})
gradientTween:Play()

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🎮 HACK MENU 🎮"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 20
titleLabel.TextStrokeTransparency = 0
titleLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 18

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Контейнер для кнопок
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Parent = mainFrame
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Position = UDim2.new(0, 20, 0, 60)
buttonsFrame.Size = UDim2.new(1, -40, 1, -80)

-- Функция создания кнопки
local function createButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = buttonsFrame
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Position = position
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.TextStrokeTransparency = 0.5
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Эффект при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Noclip функция
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end

-- ESP функция
local function createESP(targetPlayer)
    local character = targetPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    espObjects[targetPlayer] = highlight
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                createESP(targetPlayer)
            end
        end
        
        -- Добавляем ESP для новых игроков
        Players.PlayerAdded:Connect(function(newPlayer)
            if espEnabled then
                newPlayer.CharacterAdded:Connect(function()
                    wait(1)
                    createESP(newPlayer)
                end)
            end
        end)
    else
        for _, highlight in pairs(espObjects) do
            if highlight then
                highlight:Destroy()
            end
        end
        espObjects = {}
    end
end

-- Walkspeed функция
local function setWalkspeed(speed)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
        currentWalkspeed = speed
    end
end

-- Создание кнопок
local noclipButton = createButton("NoclipButton", "Noclip: OFF", UDim2.new(0, 0, 0, 0), function()
    toggleNoclip()
    noclipButton.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

local espButton = createButton("ESPButton", "ESP: OFF", UDim2.new(1, -160, 0, 0), function()
    toggleESP()
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

local speedButton1 = createButton("Speed50", "Speed: 50", UDim2.new(0, 0, 0, 50), function()
    setWalkspeed(50)
end)

local speedButton2 = createButton("Speed100", "Speed: 100", UDim2.new(1, -160, 0, 50), function()
    setWalkspeed(100)
end)

local speedButton3 = createButton("Speed16", "Speed: Normal", UDim2.new(0, 0, 0, 100), function()
    setWalkspeed(16)
end)

local speedButton4 = createButton("Speed200", "Speed: 200", UDim2.new(1, -160, 0, 100), function()
    setWalkspeed(200)
end)

-- Слайдер для walkspeed
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Parent = buttonsFrame
sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderFrame.Position = UDim2.new(0, 0, 0, 150)
sliderFrame.Size = UDim2.new(1, 0, 0, 30)

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Parent = sliderFrame
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.Size = UDim2.new(0, 30, 1, 0)
sliderButton.Text = ""

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 8)
sliderButtonCorner.Parent = sliderButton

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = sliderFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Size = UDim2.new(1, 0, 1, 0)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Walkspeed: 16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextSize = 12

-- Логика слайдера
local dragging = false
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = Players.LocalPlayer:GetMouse()
        local relativeX = mouse.X - sliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
        
        sliderButton.Position = UDim2.new(percentage, -15, 0, 0)
        
        local speed = math.floor(16 + (percentage * 284)) -- 16 to 300
        setWalkspeed(speed)
        speedLabel.Text = "Walkspeed: " .. speed
    end
end)

-- Кнопка переключения видимости (для мобильных)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Size = UDim2.new(0, isMobile and 60 or 50, 0, isMobile and 60 or 50)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "MENU"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = isMobile and 12 or 10
toggleButton.TextStrokeTransparency = 0

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Логика показа/скрытия меню
local menuVisible = true
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = menuVisible and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(100, 100, 100)
    })
    tween:Play()
end)

-- Закрытие GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Поддержка перетаскивания окна
local draggingFrame = false
local dragStart = nil
local startPos = nil

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFrame and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = false
    end
end)

-- Постоянное обновление noclip
RunService.Heartbeat:Connect(function()
    if noclipEnabled then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Автоматическое применение настроек при респавне
player.CharacterAdded:Connect(function()
    wait(1)
    if currentWalkspeed ~= 16 then
        setWalkspeed(currentWalkspeed)
    end
end)

print("🎮 Красивый Hack GUI загружен успешно!")
print("📱 Поддержка мобильных устройств: " .. (isMobile and "Включена" or "Отключена"))