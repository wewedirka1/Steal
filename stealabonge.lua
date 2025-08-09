-- Hunty Steal Script with Ultra-Compact GUI, Anti-Kick, and Old Steal by Grok
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Anti-Kick Protection
local function antiKick()
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do
        v:Disable()
    end
    game:GetService("ScriptContext").Error:Connect(function() return end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return old(self, ...)
    end)
end
antiKick()

-- GUI Setup (Hunty Steal)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HuntySteal"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Menu Button (Ultra-Compact Rounded Square)
local MenuButton = Instance.new("TextButton")
MenuButton.Size = UDim2.new(0, 40, 0, 40)
MenuButton.Position = UDim2.new(0.02, 0, 0.02, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuButton.Text = "MENU"
MenuButton.TextColor3 = Color3.fromRGB(255, 105, 180)
MenuButton.TextScaled = true
MenuButton.Font = Enum.Font.GothamBold
MenuButton.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 8)
MenuCorner.Parent = MenuButton

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(255, 105, 180)
MenuStroke.Thickness = 1.5
MenuStroke.Transparency = 0.5
MenuStroke.Parent = MenuButton

-- Main Frame (Ultra-Compact)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 220)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(255, 105, 180)
FrameStroke.Thickness = 1.5
FrameStroke.Transparency = 0.3
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BackgroundTransparency = 0.2
Title.Text = "Hunty Steal"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = Title

-- Toggle Menu Animation
local function ToggleMenu()
    local goal = MainFrame.Visible and {Size = UDim2.new(0, 150, 0, 0), BackgroundTransparency = 1} or {Size = UDim2.new(0, 150, 0, 220), BackgroundTransparency = 0.1}
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), goal)
    MainFrame.Visible = true
    tween:Play()
    tween.Completed:Connect(function()
        if MainFrame.Size.Y.Offset == 0 then
            MainFrame.Visible = false
        end
    end)
end

MenuButton.MouseButton1Click:Connect(ToggleMenu)

-- Module Toggles
local Toggles = {}
local Modules = {
    {Name = "InfinityJump", Enabled = false},
    {Name = "Speed50", Enabled = false},
    {Name = "ESP", Enabled = false},
    {Name = "Old Steal", Enabled = false}
}

for i, module in ipairs(Modules) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, 40 + (i-1)*45)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BackgroundTransparency = 0.2
    Button.Text = module.Name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 105, 180)
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Transparency = 0.5
    ButtonStroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        module.Enabled = not module.Enabled
        Button.Text = module.Name .. (module.Enabled and ": ON" or ": OFF")
        Button.BackgroundColor3 = module.Enabled and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 40)
        local scale = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = module.Enabled and UDim2.new(0.88, 0, 0, 38) or UDim2.new(0.9, 0, 0, 40)})
        scale:Play()
    end)
    Toggles[module.Name] = module
end

-- Infinity Jump (Improved Bypass)
local function SafeJump()
    if Toggles["InfinityJump"].Enabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

UserInputService.JumpRequest:Connect(SafeJump)

-- Speed Hack (Improved Bypass)
local function SafeSpeed()
    if Toggles["Speed50"].Enabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local targetSpeed = 50
            local currentSpeed = humanoid.WalkSpeed
            if math.abs(currentSpeed - targetSpeed) > 0.1 then
                humanoid.WalkSpeed = currentSpeed + (targetSpeed - currentSpeed) * 0.1
            end
        end
    elseif LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

RunService.Heartbeat:Connect(SafeSpeed)

-- ESP for Players
local function CreateESP(player)
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = player.Character.HumanoidRootPart
    Billboard.Size = UDim2.new(0, 80, 0, 40)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = player.Character

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    NameLabel.TextScaled = true
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Billboard

    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistanceLabel.TextScaled = true
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.Parent = Billboard

    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = player.Character
    Highlight.FillColor = Color3.fromRGB(255, 105, 180)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    Highlight.Parent = player.Character

    RunService.RenderStepped:Connect(function()
        if Toggles["ESP"].Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude / 3.571
            DistanceLabel.Text = string.format("%.1f m", distance)
            Billboard.Enabled = true
            Highlight.Enabled = true
        else
            Billboard.Enabled = false
            Highlight.Enabled = false
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

-- Old Steal Logic
local shotTarget = nil
local plotSigns = workspace:FindFirstChild("PlotSigns") or workspace:FindFirstChild("Plots")

local function getNearestPlayer()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local nearestPlayer, shortestDistance = nil, math.huge
    local myPosition = character.HumanoidRootPart.Position
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (hrp.Position - myPosition).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end
    return nearestPlayer
end

local function hasTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    return backpack and backpack:FindFirstChild(toolName) ~= nil
end

local function buyTool(toolName)
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Packages")
            :WaitForChild("Net"):WaitForChild("RF/CoinsShopService/RequestBuy"):InvokeServer(toolName)
    end)
    return success and result
end

local function equipTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end
    local tool = backpack:FindFirstChild(toolName)
    if not tool then return false end
    tool.Parent = LocalPlayer.Character
    return true
end

local function unequipAllTools()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = backpack
        end
    end
end

local function useWebSlinger(targetPart)
    if not targetPart then return end
    local args = {
        Vector3.new(-481, -6, -64),
        targetPart
    }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
            :WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
end

local function teleportToPosition(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local success = false
    for i = 1, 15 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))
        task.wait(0.05)
        if (hrp.Position - pos).Magnitude < 3 then
            success = true
            break
        end
    end
    return success
end

local function equipOnlyTool(toolName)
    unequipAllTools()
    if hasTool(toolName) then
        equipTool(toolName)
        task.wait(0.3)
        return true
    else
        if buyTool(toolName) then
            task.wait(0.5)
            equipTool(toolName)
            task.wait(0.3)
            return true
        end
        return false
    end
end

local function OldSteal()
    if not Toggles["Old Steal"].Enabled then
        shotTarget = nil
        return
    end

    local target = getNearestPlayer()
    if target and target.Character then
        shotTarget = target
        if not equipOnlyTool("Web Slinger") then return end
        local hand = shotTarget.Character:FindFirstChild("RightHand") or shotTarget.Character:FindFirstChild("LeftHand")
        if not hand then return end
        useWebSlinger(hand)
        task.wait(0.5)

        local function matchesName(text)
            if not text then return false end
            local targetName = string.lower(shotTarget.Name)
            local displayName = string.lower(shotTarget.DisplayName)
            text = string.lower(text)
            return string.find(text, targetName) or string.find(text, displayName)
        end

        local targetPlot = nil
        for _, plot in ipairs(plotSigns:GetDescendants()) do
            if plot:IsA("BasePart") and plot.Name == "PlotSign" then
                for _, gui in ipairs(plot:GetDescendants()) do
                    if gui:IsA("SurfaceGui") then
                        for _, label in ipairs(gui:GetDescendants()) do
                            if label:IsA("TextLabel") and matchesName(label.Text) then
                                targetPlot = plot
                                break
                            end
                        end
                    end
                end
            end
            if targetPlot then break end
        end

        if not targetPlot then return end

        local pos = targetPlot.Position
        local success = false
        for try = 1, 4 do
            if try == 4 then
                unequipAllTools()
                if not equipOnlyTool("Speed Coil") then return end
            end
            success = teleportToPosition(pos)
            if success then break end
            task.wait(0.1)
        end
        shotTarget = nil
    end
end

RunService.Heartbeat:Connect(function()
    if Toggles["Old Steal"].Enabled then
        OldSteal()
    end
end)

-- Reset on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    if char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
    local animate = char:FindFirstChild("Animate")
    if animate then
        animate.Disabled = false
    end
end)

-- Notify
print("Hunty Steal Loaded! Tap MENU to toggle the ultra-compact GUI.")
