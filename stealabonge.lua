-- CatHub Script for Murder Mystery 2
-- Features: Loading Animation, ESP for Sheriff/Murderer, Noclip, Walkspeed
-- Enhanced: Draggable GUI, Awesome Design with Gradients, Rounded Corners, Shadows, Button Animations
-- Note: This is a sample script for educational purposes. Using cheats in games like Roblox can violate terms of service and lead to bans. Use at your own risk.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Library: Using Roblox's built-in GUI with Tween animations for beauty

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CatHubGui"

-- Loading Screen
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.3
LoadingFrame.Parent = ScreenGui

-- Add Gradient to Loading Background
local LoadingGradient = Instance.new("UIGradient")
LoadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
LoadingGradient.Parent = LoadingFrame

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0.5, 0, 0.1, 0)
LoadingText.Position = UDim2.new(0.25, 0, 0.4, 0)
LoadingText.Text = "CatHub"
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 60
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.BackgroundTransparency = 1
LoadingText.Parent = LoadingFrame

-- Add Glow/Shadow to Text
local LoadingTextStroke = Instance.new("UIStroke")
LoadingTextStroke.Thickness = 2
LoadingTextStroke.Transparency = 0.5
LoadingTextStroke.Color = Color3.fromRGB(255, 0, 255)
LoadingTextStroke.Parent = LoadingText

local LoadingSubText = Instance.new("TextLabel")
LoadingSubText.Size = UDim2.new(0.5, 0, 0.05, 0)
LoadingSubText.Position = UDim2.new(0.25, 0, 0.5, 0)
LoadingSubText.Text = "Please wait, script is loading..."
LoadingSubText.Font = Enum.Font.Gotham
LoadingSubText.TextSize = 24
LoadingSubText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingSubText.BackgroundTransparency = 1
LoadingSubText.Parent = LoadingFrame

-- Loading Animation: Fade in, pulse, and rotate slightly
local function PulseAnimation(label)
    while true do
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(label, tweenInfo, {TextTransparency = 0.2, Rotation = 5}):Play()
        wait(1)
        TweenService:Create(label, tweenInfo, {TextTransparency = 0, Rotation = -5}):Play()
        wait(1)
    end
end

coroutine.wrap(PulseAnimation)(LoadingText)

-- Simulate loading time
wait(3)  -- Adjust for longer/shorter loading

-- Fade out loading screen with style
TweenService:Create(LoadingFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
TweenService:Create(LoadingText, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(LoadingSubText, TweenInfo.new(1), {TextTransparency = 1}):Play()
wait(1)
LoadingFrame:Destroy()

-- Main GUI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

-- Rounded Corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Gradient Background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
MainGradient.Parent = MainFrame

-- Shadow Effect
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Transparency = 0.8
MainStroke.Color = Color3.fromRGB(0, 0, 0)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CatHub - MM2 Script"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Draggable Functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Function to create styled buttons
local function CreateButton(parent, size, pos, text, color)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = pos
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = color
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, color:Lerp(Color3.fromRGB(0, 0, 0), 0.2))
    }
    gradient.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = button
    
    -- Hover Animation
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    return button
end

-- ESP Toggle
local ESPToggle = CreateButton(MainFrame, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.15, 0), "ESP: Off", Color3.fromRGB(100, 100, 100))

-- Sheriff/Murderer Settings
local SheriffESP = CreateButton(MainFrame, UDim2.new(0.4, 0, 0, 40), UDim2.new(0.1, 0, 0.3, 0), "Sheriff ESP: On", Color3.fromRGB(0, 100, 255))
SheriffESP.TextColor3 = Color3.fromRGB(0, 255, 0)

local MurdererESP = CreateButton(MainFrame, UDim2.new(0.4, 0, 0, 40), UDim2.new(0.5, 0, 0.3, 0), "Murderer ESP: On", Color3.fromRGB(255, 50, 50))
MurdererESP.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Noclip Toggle
local NoclipToggle = CreateButton(MainFrame, UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.45, 0), "Noclip: Off", Color3.fromRGB(100, 100, 100))

-- Walkspeed
local WalkspeedFrame = Instance.new("Frame")
WalkspeedFrame.Size = UDim2.new(0.8, 0, 0, 40)
WalkspeedFrame.Position = UDim2.new(0.1, 0, 0.6, 0)
WalkspeedFrame.BackgroundTransparency = 1
WalkspeedFrame.Parent = MainFrame

local WalkspeedLabel = Instance.new("TextLabel")
WalkspeedLabel.Size = UDim2.new(0.5, 0, 1, 0)
WalkspeedLabel.Text = "Walkspeed:"
WalkspeedLabel.Font = Enum.Font.Gotham
WalkspeedLabel.TextSize = 18
WalkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkspeedLabel.BackgroundTransparency = 1
WalkspeedLabel.Parent = WalkspeedFrame

local WalkspeedBox = Instance.new("TextBox")
WalkspeedBox.Size = UDim2.new(0.5, 0, 1, 0)
WalkspeedBox.Text = "16"
WalkspeedBox.Font = Enum.Font.Gotham
WalkspeedBox.TextSize = 18
WalkspeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkspeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkspeedBox.Parent = WalkspeedFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = WalkspeedBox

local BoxGradient = Instance.new("UIGradient")
BoxGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
}
BoxGradient.Parent = WalkspeedBox

-- Animate MainFrame In with bounce
MainFrame.Visible = true
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -300)  -- Start above
TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -200)}):Play()

-- ESP Functionality (unchanged)
local ESPEnabled = false
local SheriffESPEnabled = true
local MurdererESPEnabled = true

local Highlights = {}

local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.Adornee = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    Highlights[player] = highlight
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local backpack = player:FindFirstChild("Backpack") or player.Character:FindFirstChildOfClass("Backpack")
            local tool = player.Character:FindFirstChildOfClass("Tool")
            
            local isSheriff = false
            local isMurderer = false
            
            if tool then
                if tool.Name == "Gun" then isSheriff = true end
                if tool.Name == "Knife" then isMurderer = true end
            elseif backpack then
                if backpack:FindFirstChild("Gun") then isSheriff = true end
                if backpack:FindFirstChild("Knife") then isMurderer = true end
            end
            
            local highlight = Highlights[player]
            if not highlight then
                CreateESP(player)
                highlight = Highlights[player]
            end
            
            if ESPEnabled then
                if (isSheriff and SheriffESPEnabled) then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                    highlight.Enabled = true
                elseif (isMurderer and MurdererESPEnabled) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.Enabled = true
                else
                    highlight.Enabled = false
                end
            else
                highlight.Enabled = false
            end
        end
    end
end

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "On" or "Off")
    ESPToggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    UpdateESP()
end)

SheriffESP.MouseButton1Click:Connect(function()
    SheriffESPEnabled = not SheriffESPEnabled
    SheriffESP.Text = "Sheriff ESP: " .. (SheriffESPEnabled and "On" or "Off")
    SheriffESP.TextColor3 = SheriffESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    UpdateESP()
end)

MurdererESP.MouseButton1Click:Connect(function()
    MurdererESPEnabled = not MurdererESPEnabled
    MurdererESP.Text = "Murderer ESP: " .. (MurdererESPEnabled and "On" or "Off")
    MurdererESP.TextColor3 = MurdererESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    UpdateESP()
end)

RunService.RenderStepped:Connect(UpdateESP)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        UpdateESP()
    end)
end)

-- Noclip Functionality
local NoclipEnabled = false
local function NoclipLoop()
    if NoclipEnabled then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

RunService.Stepped:Connect(NoclipLoop)

NoclipToggle.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipToggle.Text = "Noclip: " .. (NoclipEnabled and "On" or "Off")
    NoclipToggle.BackgroundColor3 = NoclipEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
end)

-- Walkspeed
WalkspeedBox.FocusLost:Connect(function()
    local speed = tonumber(WalkspeedBox.Text)
    if speed then
        Humanoid.WalkSpeed = speed
    end
end)

-- Handle Character Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    WalkspeedBox.Text = tostring(Humanoid.WalkSpeed)
end)

-- Close GUI with keybind (RightShift)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("CatHub Loaded!")
