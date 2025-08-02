-- ESP GUI с мобильной поддержкой
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Проверка на мобильное устройство
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Конфиг по умолчанию
local Config = {
    ESPEnabled = true,
    PlayerESP = true,
    MobESP = true,
    HeadSize = 10,
    PlayerColor = Color3.fromRGB(0, 170, 255),
    MobColor = Color3.fromRGB(255, 0, 0),
    Transparency = 0.7,
    PartMaterial = "Neon",
    HighlightEnabled = true,
    FillTransparency = 0.3
}

-- Сохранение конфига
local function saveConfig()
    local configString = ""
    for key, value in pairs(Config) do
        if typeof(value) == "Color3" then
            configString = configString .. key .. "=" .. value.R .. "," .. value.G .. "," .. value.B .. ";"
        else
            configString = configString .. key .. "=" .. tostring(value) .. ";"
        end
    end
    _G.SavedESPConfig = configString
    print("Конфиг сохранен!")
end

-- Загрузка конфига
local function loadConfig()
    if _G.SavedESPConfig then
        local configString = _G.SavedESPConfig
        for pair in configString:gmatch("([^;]+)") do
            local key, value = pair:match("([^=]+)=(.+)")
            if key and value then
                if key:find("Color") then
                    local r, g, b = value:match("([^,]+),([^,]+),(.+)")
                    if r and g and b then
                        Config[key] = Color3.fromRGB(tonumber(r) * 255, tonumber(g) * 255, tonumber(b) * 255)
                    end
                elseif value == "true" or value == "false" then
                    Config[key] = value == "true"
                elseif tonumber(value) then
                    Config[key] = tonumber(value)
                else
                    Config[key] = value
                end
            end
        end
        print("Конфиг загружен!")
    end
end

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPConfigGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- МОБИЛЬНАЯ КНОПКА G (кружочек)
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileButton"
MobileButton.Size = UDim2.new(0, 80, 0, 80)
MobileButton.Position = UDim2.new(0, 20, 0, 100)
MobileButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MobileButton.Text = "G"
MobileButton.TextColor3 = Color3.new(1, 1, 1)
MobileButton.TextScaled = true
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Active = true
MobileButton.Draggable = true
MobileButton.Parent = ScreenGui

-- Делаем кнопку круглой
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.5, 0)
ButtonCorner.Parent = MobileButton

-- Тень для кнопки
local ButtonShadow = Instance.new("Frame")
ButtonShadow.Name = "Shadow"
ButtonShadow.Size = UDim2.new(1, 6, 1, 6)
ButtonShadow.Position = UDim2.new(0, -3, 0, -3)
ButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ButtonShadow.BackgroundTransparency = 0.5
ButtonShadow.ZIndex = MobileButton.ZIndex - 1
ButtonShadow.Parent = MobileButton

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0.5, 0)
ShadowCorner.Parent = ButtonShadow

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 400, 0, 500)
MainFrame.Position = isMobile and UDim2.new(0.05, 0, 0.1, 0) or UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = not isMobile
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Скругление углов
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, isMobile and 60 or 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "ESP CONFIG"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, isMobile and 50 or 30, 0, isMobile and 50 or 30)
CloseButton.Position = UDim2.new(1, isMobile and -60 or -35, 0, isMobile and 5 or 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Скролл контейнер
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, isMobile and -120 or -90)
ScrollFrame.Position = UDim2.new(0, 10, 0, isMobile and 70 or 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = isMobile and 15 or 8
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, isMobile and 15 or 10)
Layout.Parent = ScrollFrame

-- Функция создания чекбокса (адаптивный для мобилки)
local function createCheckbox(name, configKey)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "Frame"
    Frame.Size = UDim2.new(1, -20, 0, isMobile and 60 or 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 45 or 30)
    Checkbox.Position = UDim2.new(1, isMobile and -90 or -70, 0.5, isMobile and -22.5 or -15)
    Checkbox.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Checkbox.Text = Config[configKey] and "ON" or "OFF"
    Checkbox.TextColor3 = Color3.new(1, 1, 1)
    Checkbox.TextScaled = true
    Checkbox.Font = Enum.Font.GothamBold
    Checkbox.Parent = Frame
    
    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 8)
    CheckCorner.Parent = Checkbox
    
    Checkbox.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        Checkbox.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        Checkbox.Text = Config[configKey] and "ON" or "OFF"
        
        -- Анимация нажатия
        TweenService:Create(Checkbox, TweenInfo.new(0.1), {Size = UDim2.new(0, isMobile and 75 or 55, 0, isMobile and 40 or 25)}):Play()
        wait(0.1)
        TweenService:Create(Checkbox, TweenInfo.new(0.1), {Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 45 or 30)}):Play()
    end)
end

-- Функция создания слайдера (адаптивный для мобилки)
local function createSlider(name, configKey, minVal, maxVal)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "Frame"
    Frame.Size = UDim2.new(1, -20, 0, isMobile and 80 : 60)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, isMobile and 35 or 25)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. Config[configKey]
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, 0, 0, isMobile and 30 or 20)
    SliderBack.Position = UDim2.new(0, 0, 0, isMobile and 40 or 30)
    SliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBack.Parent = Frame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 15)
    SliderCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Config[configKey] - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.Parent = SliderBack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 15)
    FillCorner.Parent = SliderFill
    
    -- Ползунок для мобилки
    local SliderHandle = Instance.new("Frame")
    SliderHandle.Size = UDim2.new(0, isMobile and 25 or 15, 1, isMobile and 10 or 5)
    SliderHandle.Position = UDim2.new((Config[configKey] - minVal) / (maxVal - minVal), isMobile and -12.5 or -7.5, 0, isMobile and -5 or -2.5)
    SliderHandle.BackgroundColor3 = Color3.new(1, 1, 1)
    SliderHandle.Parent = SliderBack
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(0.5, 0)
    HandleCorner.Parent = SliderHandle
    
    local dragging = false
    
    local function updateSlider(input)
        if dragging then
            local relative = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            
            Config[configKey] = minVal + (maxVal - minVal) * relative
            if configKey == "HeadSize" then
                Config[configKey] = math.floor(Config[configKey])
            end
            
            SliderFill.Size = UDim2.new(relative, 0, 1, 0)
            SliderHandle.Position = UDim2.new(relative, isMobile and -12.5 or -7.5, 0, isMobile and -5 or -2.5)
            Label.Text = name .. ": " .. Config[configKey]
        end
    end
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)
end

-- Создание элементов интерфейса
createCheckbox("ESP Включен", "ESPEnabled")
createCheckbox("ESP Игроков", "PlayerESP")
createCheckbox("ESP Мобов", "MobESP")
createCheckbox("Подсветка", "HighlightEnabled")

createSlider("Размер головы", "HeadSize", 1, 50)
createSlider("Прозрачность", "Transparency", 0, 1)
createSlider("Прозрачность подсветки", "FillTransparency", 0, 1)

-- Кнопки сохранения и загрузки
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Name = "ButtonFrame"
ButtonFrame.Size = UDim2.new(1, -20, 0, isMobile and 60 or 40)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = ScrollFrame

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0.45, 0, 1, 0)
SaveButton.Position = UDim2.new(0, 0, 0, 0)
SaveButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
SaveButton.Text = "СОХРАНИТЬ"
SaveButton.TextColor3 = Color3.new(1, 1, 1)
SaveButton.TextScaled = true
SaveButton.Font = Enum.Font.GothamBold
SaveButton.Parent = ButtonFrame

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 10)
SaveCorner.Parent = SaveButton

local LoadButton = Instance.new("TextButton")
LoadButton.Size = UDim2.new(0.45, 0, 1, 0)
LoadButton.Position = UDim2.new(0.55, 0, 0, 0)
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
LoadButton.Text = "ЗАГРУЗИТЬ"
LoadButton.TextColor3 = Color3.new(1, 1, 1)
LoadButton.TextScaled = true
LoadButton.Font = Enum.Font.GothamBold
LoadButton.Parent = ButtonFrame

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 10)
LoadCorner.Parent = LoadButton

-- Анимация открытия/закрытия
local function toggleMenu()
    local isVisible = MainFrame.Visible
    
    if not isVisible then
        MainFrame.Visible = true
        MainFrame.Size = isMobile and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
        MainFrame.Position = isMobile and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 400, 0, 500),
            Position = isMobile and UDim2.new(0.05, 0, 0.1, 0) or UDim2.new(0.5, -200, 0.5, -250)
        }):Play()
        
        -- Анимация кнопки
        TweenService:Create(MobileButton, TweenInfo.new(0.2), {Rotation = 45}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = isMobile and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.2)
        MainFrame.Visible = false
        
        -- Анимация кнопки
        TweenService:Create(MobileButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
    end
end

-- События кнопок
SaveButton.MouseButton1Click:Connect(function()
    saveConfig()
    -- Эффект нажатия
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
    wait(0.1)
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 0)}):Play()
end)

LoadButton.MouseButton1Click:Connect(function()
    loadConfig()
    -- Эффект нажатия
    TweenService:Create(LoadButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 200)}):Play()
    wait(0.1)
    TweenService:Create(LoadButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
end)

CloseButton.MouseButton1Click:Connect(toggleMenu)
MobileButton.MouseButton1Click:Connect(toggleMenu)

-- Управление с клавиатуры (для ПК)
if not isMobile then
    UserInputService.InputBegan:Connect(function(key)
        if key.KeyCode == Enum.KeyCode.RightControl then
            toggleMenu()
        end
    end)
end

-- ESP функции из оригинального скрипта
local MobsFolder = workspace:FindFirstChild("Mobs")

local function applyPropertiesToPart(part)
    if part then
        part.Size = Vector3.new(Config.HeadSize, Config.HeadSize, Config.HeadSize)
        part.Transparency = Config.Transparency
        part.BrickColor = BrickColor.new("Really blue")
        part.Material = Enum.Material[Config.PartMaterial]
        part.CanCollide = false
    end
end

local function applyHighlight(model, color)
    if not Config.HighlightEnabled then return end
    
    if not model:FindFirstChild("HighlightESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.FillTransparency = Config.FillTransparency
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
        highlight.Adornee = model
    end
end

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if Config.ESPEnabled then
        if Config.PlayerESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        applyPropertiesToPart(player.Character.HumanoidRootPart)
                        applyHighlight(player.Character, Config.PlayerColor)
                    end)
                end
            end
        end

        if Config.MobESP and MobsFolder then
            for _, mob in ipairs(MobsFolder:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        applyPropertiesToPart(mob.HumanoidRootPart)
                        applyHighlight(mob, Config.MobColor)
                    end)
                end
            end
        end
    end
end)

-- Загрузка конфига при запуске
loadConfig()

if isMobile then
    print("ESP GUI загружен для мобилки! Нажми кнопку G для открытия меню")
else
    print("ESP GUI загружен! Нажми Right Ctrl или кнопку G для открытия")
end
