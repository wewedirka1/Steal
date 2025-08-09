-- HuntyHub Script with Compact GUI and Improved Bypasses by Grok
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI Setup (HuntyHub)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HuntyHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Menu Button (Rounded Square)
local MenuButton = Instance.new("TextButton")
MenuButton.Size = UDim2.new(0, 50, 0, 50)
MenuButton.Position = UDim2.new(0.02, 0, 0.02, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuButton.Text = "MENU"
MenuButton.TextColor3 = Color3.fromRGB(255, 105, 180)
MenuButton.TextScaled = true
MenuButton.Font = Enum.Font.GothamBold
MenuButton.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MenuButton

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(255, 105, 180)
MenuStroke.Thickness = 2
MenuStroke.Transparency = 0.5
MenuStroke.Parent = MenuButton

-- Main Frame (Compact)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(255, 105, 180)
FrameStroke.Thickness = 2
FrameStroke.Transparency = 0.3
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BackgroundTransparency = 0.2
Title.Text = "HuntyHub"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Toggle Menu Animation
local function ToggleMenu()
    local goal = MainFrame.Visible and {Size = UDim2.new(0, 200, 0, 0), BackgroundTransparency = 1} or {Size = UDim2.new(0, 200, 0, 300), BackgroundTransparency = 0.1}
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
    {Name = "ESP", Enabled = false}
}

for i, module in ipairs(Modules) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 50)
    Button.Position = UDim2.new(0.05, 0, 0, 50 + (i-1)*60)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BackgroundTransparency = 0.2
    Button.Text = module.Name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 105, 180)
    ButtonStroke.Thickness = 2
    ButtonStroke.Transparency = 0.5
    ButtonStroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        module.Enabled = not module.Enabled
        Button.Text = module.Name .. (module.Enabled and ": ON" or ": OFF")
        Button.BackgroundColor3 = module.Enabled and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 40)
        local scale = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = module.Enabled and UDim2.new(0.88, 0, 0, 48) or UDim2.new(0.9, 0, 0, 50)})
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
            -- Gradually adjust speed to avoid detection
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
    Billboard.Size = UDim2.new(0, 100, 0, 50)
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
            DistanceLabel.Text = string.format("%.1f meters", distance)
            Billboard.Enabled = true
            Highlight.Enabled = true
        else
            Billboard.Enabled = false
            Highlight.Enabled = false
        end
    end)
end

-- Apply ESP to existing players
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

-- Apply ESP to new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

-- Notify
print("HuntyHub Loaded! Tap MENU to toggle the compact GUI.")
