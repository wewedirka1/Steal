-- CatHub Script for Murder Mystery 2
-- Features: Loading Animation, ESP for Sheriff/Murderer, Noclip, Walkspeed
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
LoadingFrame.BackgroundTransparency = 0.5
LoadingFrame.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0.5, 0, 0.1, 0)
LoadingText.Position = UDim2.new(0.25, 0, 0.4, 0)
LoadingText.Text = "CatHub"
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 50
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.BackgroundTransparency = 1
LoadingText.Parent = LoadingFrame

local LoadingSubText = Instance.new("TextLabel")
LoadingSubText.Size = UDim2.new(0.5, 0, 0.05, 0)
LoadingSubText.Position = UDim2.new(0.25, 0, 0.5, 0)
LoadingSubText.Text = "Please wait, script is loading..."
LoadingSubText.Font = Enum.Font.Gotham
LoadingSubText.TextSize = 20
LoadingSubText.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingSubText.BackgroundTransparency = 1
LoadingSubText.Parent = LoadingFrame

-- Loading Animation: Fade in and pulse
local function PulseAnimation(label)
    while true do
        TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.5}):Play()
        wait(1)
        TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
        wait(1)
    end
end

coroutine.wrap(PulseAnimation)(LoadingText)

-- Simulate loading time
wait(3)  -- Adjust for longer/shorter loading

-- Fade out loading screen
TweenService:Create(LoadingFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
wait(1)
LoadingFrame:Destroy()

-- Main GUI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false  -- Will animate in

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "CatHub - MM2 Script"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0.8, 0, 0.1, 0)
ESPToggle.Position = UDim2.new(0.1, 0, 0.15, 0)
ESPToggle.Text = "ESP: Off"
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 18
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = MainFrame

-- Sheriff/Murderer Settings (Toggles)
local SheriffESP = Instance.new("TextButton")
SheriffESP.Size = UDim2.new(0.4, 0, 0.1, 0)
SheriffESP.Position = UDim2.new(0.1, 0, 0.3, 0)
SheriffESP.Text = "Sheriff ESP: On"
SheriffESP.Font = Enum.Font.Gotham
SheriffESP.TextSize = 16
SheriffESP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SheriffESP.TextColor3 = Color3.fromRGB(0, 255, 0)
SheriffESP.Parent = MainFrame

local MurdererESP = Instance.new("TextButton")
MurdererESP.Size = UDim2.new(0.4, 0, 0.1, 0)
MurdererESP.Position = UDim2.new(0.5, 0, 0.3, 0)
MurdererESP.Text = "Murderer ESP: On"
MurdererESP.Font = Enum.Font.Gotham
MurdererESP.TextSize = 16
MurdererESP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MurdererESP.TextColor3 = Color3.fromRGB(255, 0, 0)
MurdererESP.Parent = MainFrame

-- Noclip Toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0.8, 0, 0.1, 0)
NoclipToggle.Position = UDim2.new(0.1, 0, 0.45, 0)
NoclipToggle.Text = "Noclip: Off"
NoclipToggle.Font = Enum.Font.Gotham
NoclipToggle.TextSize = 18
NoclipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Parent = MainFrame

-- Walkspeed Slider (Simple TextBox for value)
local WalkspeedLabel = Instance.new("TextLabel")
WalkspeedLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
WalkspeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
WalkspeedLabel.Text = "Walkspeed:"
WalkspeedLabel.Font = Enum.Font.Gotham
WalkspeedLabel.TextSize = 18
WalkspeedLabel.BackgroundTransparency = 1
WalkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkspeedLabel.Parent = MainFrame

local WalkspeedBox = Instance.new("TextBox")
WalkspeedBox.Size = UDim2.new(0.4, 0, 0.1, 0)
WalkspeedBox.Position = UDim2.new(0.5, 0, 0.6, 0)
WalkspeedBox.Text = "16"  -- Default
WalkspeedBox.Font = Enum.Font.Gotham
WalkspeedBox.TextSize = 18
WalkspeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkspeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkspeedBox.Parent = MainFrame

-- Animate MainFrame In
MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.35, 0, 0.25, 0), Size = UDim2.new(0.3, 0, 0.5, 0)}):Play()  -- Assuming starts off-screen or small

-- ESP Functionality
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
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)  -- Blue for Sheriff
                    highlight.Enabled = true
                elseif (isMurderer and MurdererESPEnabled) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Red for Murderer
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

-- Toggle ESP
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "On" or "Off")
    UpdateESP()
end)

-- Toggle Sheriff ESP
SheriffESP.MouseButton1Click:Connect(function()
    SheriffESPEnabled = not SheriffESPEnabled
    SheriffESP.Text = "Sheriff ESP: " .. (SheriffESPEnabled and "On" or "Off")
    SheriffESP.TextColor3 = SheriffESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    UpdateESP()
end)

-- Toggle Murderer ESP
MurdererESP.MouseButton1Click:Connect(function()
    MurdererESPEnabled = not MurdererESPEnabled
    MurdererESP.Text = "Murderer ESP: " .. (MurdererESPEnabled and "On" or "Off")
    MurdererESP.TextColor3 = MurdererESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    UpdateESP()
end)

-- Run ESP update every frame
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
    WalkspeedBox.Text = tostring(Humanoid.WalkSpeed)  -- Reset to current
end)

-- Close GUI with keybind (e.g., RightShift)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("CatHub Loaded!")
