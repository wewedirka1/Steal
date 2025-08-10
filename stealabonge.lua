-- Roblox Cheat Script: Aimbot with FOV Circle, Silent Aim, ESP, and Neverlose-like GUI
-- Opens on 'M' key
-- Note: This script assumes you're using an exploit that supports Drawing API and UserInputService.
-- For Silent Aim, it hooks raycasting (works in games using workspace:FindPartOnRay).
-- Customize for specific games if needed.
-- GUI uses a simple custom menu inspired by Neverlose style (tabs, toggles, sliders). Not using external libs for self-containment.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Settings
local AimbotEnabled = false
local SilentAimEnabled = false
local FOVRadius = 150  -- FOV circle radius
local ShowFOVCircle = true
local ESPEnabled = false
local MenuVisible = false

-- GUI Elements (Simple Neverlose-like menu using ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui  -- Use CoreGui for overlay
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Neverlose-like Cheat Menu for Roblox"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = MainFrame

-- Tabs (Simple buttons for tabs)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabFrame.Parent = MainFrame

local AimbotTabButton = Instance.new("TextButton")
AimbotTabButton.Size = UDim2.new(0.5, 0, 1, 0)
AimbotTabButton.Text = "Aimbot"
AimbotTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotTabButton.Parent = TabFrame

local VisualsTabButton = Instance.new("TextButton")
VisualsTabButton.Size = UDim2.new(0.5, 0, 1, 0)
VisualsTabButton.Position = UDim2.new(0.5, 0, 0, 0)
VisualsTabButton.Text = "Visuals"
VisualsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
VisualsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualsTabButton.Parent = TabFrame

-- Content Frames
local AimbotContent = Instance.new("Frame")
AimbotContent.Size = UDim2.new(1, 0, 1, -60)
AimbotContent.Position = UDim2.new(0, 0, 0, 60)
AimbotContent.BackgroundTransparency = 1
AimbotContent.Parent = MainFrame
AimbotContent.Visible = true

local VisualsContent = Instance.new("Frame")
VisualsContent.Size = UDim2.new(1, 0, 1, -60)
VisualsContent.Position = UDim2.new(0, 0, 0, 60)
VisualsContent.BackgroundTransparency = 1
VisualsContent.Parent = MainFrame
VisualsContent.Visible = false

-- Aimbot Controls
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, 0, 0, 30)
AimbotToggle.Text = "Aimbot: Off"
AimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Parent = AimbotContent
AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (AimbotEnabled and "On" or "Off")
end)

local SilentAimToggle = Instance.new("TextButton")
SilentAimToggle.Size = UDim2.new(1, 0, 0, 30)
SilentAimToggle.Position = UDim2.new(0, 0, 0, 30)
SilentAimToggle.Text = "Silent Aim: Off"
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentAimToggle.Parent = AimbotContent
SilentAimToggle.MouseButton1Click:Connect(function()
    SilentAimEnabled = not SilentAimEnabled
    SilentAimToggle.Text = "Silent Aim: " .. (SilentAimEnabled and "On" or "Off")
end)

local FOVSliderLabel = Instance.new("TextLabel")
FOVSliderLabel.Size = UDim2.new(1, 0, 0, 30)
FOVSliderLabel.Position = UDim2.new(0, 0, 0, 60)
FOVSliderLabel.Text = "FOV Radius: 150"
FOVSliderLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVSliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVSliderLabel.Parent = AimbotContent

-- Simple slider simulation (click to increase/decrease)
FOVSliderLabel.MouseButton1Click:Connect(function()
    FOVRadius = FOVRadius + 10
    if FOVRadius > 500 then FOVRadius = 50 end
    FOVSliderLabel.Text = "FOV Radius: " .. FOVRadius
end)

-- Visuals Controls
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Text = "ESP: Off"
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = VisualsContent
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "On" or "Off")
end)

local FOVCircleToggle = Instance.new("TextButton")
FOVCircleToggle.Size = UDim2.new(1, 0, 0, 30)
FOVCircleToggle.Position = UDim2.new(0, 0, 0, 30)
FOVCircleToggle.Text = "Show FOV Circle: On"
FOVCircleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVCircleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVCircleToggle.Parent = VisualsContent
FOVCircleToggle.MouseButton1Click:Connect(function()
    ShowFOVCircle = not ShowFOVCircle
    FOVCircleToggle.Text = "Show FOV Circle: " .. (ShowFOVCircle and "On" or "Off")
end)

-- Tab Switching
AimbotTabButton.MouseButton1Click:Connect(function()
    AimbotContent.Visible = true
    VisualsContent.Visible = false
end)

VisualsTabButton.MouseButton1Click:Connect(function()
    AimbotContent.Visible = false
    VisualsContent.Visible = true
end)

-- Menu Toggle on 'M'
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        Mouse.Icon = MenuVisible and "rbxasset://textures\\GunWaitCursor.png" or "rbxasset://textures\\GunCursor.png"
    end
end)

-- FOV Circle (using Drawing API)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ESP Drawings
local ESPDrawings = {}

local function AddESP(player)
    if player == LocalPlayer or not player.Character then return end
    local Box = Drawing.new("Square")
    Box.Thickness = 1
    Box.Color = Color3.fromRGB(0, 255, 0)
    Box.Filled = false
    Box.Transparency = 1
    Box.Visible = false
    
    local Name = Drawing.new("Text")
    Name.Text = player.Name
    Name.Size = 16
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Transparency = 1
    Name.Visible = false
    Name.Center = true
    
    ESPDrawings[player] = {Box = Box, Name = Name}
end

local function UpdateESP()
    for player, drawings in pairs(ESPDrawings) do
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            
            if onScreen then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local size = Vector2.new(math.abs(top.Y - bottom.Y) / 2, math.abs(top.Y - bottom.Y))
                
                drawings.Box.Size = size
                drawings.Box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                drawings.Box.Visible = true
                
                drawings.Name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 20)
                drawings.Name.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Name.Visible = false
        end
    end
end

-- Add ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    AddESP(player)
end

-- Add for new players
Players.PlayerAdded:Connect(AddESP)

-- Remove on leave
Players.PlayerRemoving:Connect(function(player)
    if ESPDrawings[player] then
        ESPDrawings[player].Box:Remove()
        ESPDrawings[player].Name:Remove()
        ESPDrawings[player] = nil
    end
end)

-- Get Closest Player in FOV
local function GetClosestPlayerInFOV()
    local closest = nil
    local minDist = FOVRadius
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
            local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position)
            local dist = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
            if dist < minDist then
                minDist = dist
                closest = player
            end
        end
    end
    return closest
end

-- Aimbot (Visible Aim Lock)
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
        end
    end
    
    -- Update FOV Circle
    FOVCircle.Radius = FOVRadius
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + GuiService:GetGuiInset().Y)
    FOVCircle.Visible = ShowFOVCircle
    
    -- Update ESP
    UpdateESP()
end)

-- Silent Aim Hook (Hooks workspace:FindPartOnRayWithIgnoreList)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if SilentAimEnabled and getnamecallmethod() == "FindPartOnRayWithIgnoreList" and self == Workspace then
        local target = GetClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- Redirect ray to head
            local origin = args[1].Origin
            local direction = (target.Character.Head.Position - origin).Unit * 1000  -- Long ray
            args[1] = Ray.new(origin, direction)
        end
    end
    return oldNamecall(self, unpack(args))
end)

print("Script Loaded! Press 'M' to open menu.")
