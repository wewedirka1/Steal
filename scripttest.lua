-- Blade Ball Modern GUI Script
-- Красивый интерфейс с анимациями и современным дизайном

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Настройки
local Settings = {
    AutoParry = false,
    BallESP = true,
    ShowDistance = true,
    PlayerESP = false,
    ParryDistance = 15,
    ESPColor = Color3.new(1, 0.2, 0.2),
    DistanceColor = Color3.new(0.2, 1, 0.2),
    PlayerColor = Color3.new(0.2, 0.2, 1)
}

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BladeballGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Градиент фон
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Тень
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Заголовок текст
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🗡️ BLADE BALL HACK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Версия
local version = Instance.new("TextLabel")
version.Name = "Version"
version.Size = UDim2.new(0, 80, 1, 0)
version.Position = UDim2.new(1, -90, 0, 0)
version.BackgroundTransparency = 1
version.Text = "v2.1"
version.TextColor3 = Color3.fromRGB(100, 255, 100)
version.TextSize = 12
version.TextXAlignment = Enum.TextXAlignment.Right
version.Font = Enum.Font.Gotham
version.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Контейнер для контента
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Функция создания переключателя
local function createToggle(name, position, enabled, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 60)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = contentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(1, -120, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.Size = UDim2.new(0, 80, 0, 30)
    toggleSwitch.Position = UDim2.new(1, -95, 0.5, -15)
    toggleSwitch.BackgroundColor3 = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(80, 80, 80)
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 15)
    switchCorner.Parent = toggleSwitch
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 26, 0, 26)
    toggleCircle.Position = enabled and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleSwitch
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 13)
    circleCorner.Parent = toggleCircle
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleFrame
    
    local isEnabled = enabled
    
    button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        
        local switchTween = TweenService:Create(
            toggleSwitch,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundColor3 = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(80, 80, 80)}
        )
        
        local circleTween = TweenService:Create(
            toggleCircle,
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = isEnabled and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)}
        )
        
        switchTween:Play()
        circleTween:Play()
        
        callback(isEnabled)
    end)
    
    -- Hover эффект
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(
            toggleFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}
        )
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local hoverTween = TweenService:Create(
            toggleFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}
        )
        hoverTween:Play()
    end)
    
    return toggleFrame
end

-- Функция создания слайдера
local function createSlider(name, position, minValue, maxValue, currentValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 80)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = contentFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(1, -20, 0, 30)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name
    sliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 60, 0, 30)
    valueLabel.Position = UDim2.new(1, -70, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentValue)
    valueLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, -40, 0, 6)
    sliderTrack.Position = UDim2.new(0, 20, 1, -25)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderTrack
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = sliderHandle
    
    local dragging = false
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition.X
            local trackSize = sliderTrack.AbsoluteSize.X
            local relativePos = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * relativePos)
            
            sliderHandle.Position = UDim2.new(relativePos, -8, 0.5, -8)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            valueLabel.Text = tostring(value)
            
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- Создание статистики
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(1, 0, 0, 80)
statsFrame.Position = UDim2.new(0, 0, 1, -90)
statsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = contentFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0.5, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Скрипт активен"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = statsFrame

local ballDistanceLabel = Instance.new("TextLabel")
ballDistanceLabel.Name = "BallDistanceLabel"
ballDistanceLabel.Size = UDim2.new(1, -20, 0.5, 0)
ballDistanceLabel.Position = UDim2.new(0, 10, 0.5, 0)
ballDistanceLabel.BackgroundTransparency = 1
ballDistanceLabel.Text = "Дистанция до мяча: --"
ballDistanceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ballDistanceLabel.TextSize = 12
ballDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
ballDistanceLabel.Font = Enum.Font.Gotham
ballDistanceLabel.Parent = statsFrame

-- Создание переключателей
createToggle("Auto Parry", UDim2.new(0, 0, 0, 10), Settings.AutoParry, function(enabled)
    Settings.AutoParry = enabled
end)

createToggle("Ball ESP", UDim2.new(0, 0, 0, 80), Settings.BallESP, function(enabled)
    Settings.BallESP = enabled
end)

createToggle("Show Distance", UDim2.new(0, 0, 0, 150), Settings.ShowDistance, function(enabled)
    Settings.ShowDistance = enabled
end)

createToggle("Player ESP", UDim2.new(0, 0, 0, 220), Settings.PlayerESP, function(enabled)
    Settings.PlayerESP = enabled
end)

-- Создание слайдера дистанции
createSlider("Parry Distance", UDim2.new(0, 0, 0, 290), 5, 50, Settings.ParryDistance, function(value)
    Settings.ParryDistance = value
end)

-- Логика ESP и автопарри (упрощенная версия)
local ballESP = nil
local playerESPs = {}

local function findBall()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Ball" and obj:FindFirstChild("Zap") then
            return obj
        end
    end
    return nil
end

local function createESP(object, name, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = name .. "ESP"
    billboardGui.Adornee = object
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboardGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = color
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Settings.DistanceColor
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.Parent = frame
    
    return billboardGui, distanceLabel
end

local function parry()
    local parryEvent = ReplicatedStorage:FindFirstChild("Remotes")
    if parryEvent and parryEvent:FindFirstChild("ParryAttempt") then
        parryEvent.ParryAttempt:FireServer(0.5, CFrame.new(), {[1] = 0, [2] = 0}, {0, 0})
    end
end

-- Основной цикл
local connection = RunService.Heartbeat:Connect(function()
    if not character or not character.Parent then
        character = player.Character
        if character then
            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        end
        return
    end
    
    local ball = findBall()
    
    if ball and Settings.BallESP then
        if not ballESP or not ballESP.Parent then
            ballESP, distanceLabel = createESP(ball, "BALL", Settings.ESPColor)
        end
        
        if humanoidRootPart and Settings.ShowDistance and distanceLabel then
            local distance = (ball.Position - humanoidRootPart.Position).Magnitude
            distanceLabel.Text = math.floor(distance) .. "m"
            ballDistanceLabel.Text = "Дистанция до мяча: " .. math.floor(distance) .. "m"
            
            if Settings.AutoParry and distance <= Settings.ParryDistance then
                local ballVelocity = ball.AssemblyLinearVelocity
                if ballVelocity.Magnitude > 10 then
                    parry()
                    wait(0.1)
                end
            end
        end
    else
        if ballESP then
            ballESP:Destroy()
            ballESP = nil
        end
        ballDistanceLabel.Text = "Дистанция до мяча: --"
    end
end)

-- Анимация появления GUI
local function animateIn()
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 400, 0, 500),
            Position = UDim2.new(0.5, -200, 0.5, -250)
        }
    )
    tween:Play()
end

-- Обработчик закрытия
closeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        screenGui:Destroy()
        connection:Disconnect()
    end)
end)

-- Запуск анимации
animateIn()

-- Обновление персонажа
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

print("🗡️ Blade Ball Modern GUI загружен!")
print("✨ Функции: Auto Parry, Ball ESP, Player ESP, Distance Indicator")