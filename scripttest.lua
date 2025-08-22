-- Basic script for Roblox Rivals: Fixed center circle (like aimbot FOV) and beautiful ESP
-- This assumes you're using a Roblox exploit that supports Drawing API (e.g., Synapse, Krnl)
-- Note: This is for educational purposes. Using cheats can result in bans. Use at your own risk.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local CircleRadius = 150  -- Adjust FOV circle size
local CircleColor = Color3.fromRGB(255, 0, 0)  -- Red circle
local ESPThickness = 1
local ESPTransparency = 0.7
local ShowName = true
local ShowHealth = true
local ShowDistance = true
local MaxDistance = 1000  -- Max distance to show ESP

-- Create fixed circle in center (doesn't move, always centered)
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Radius = CircleRadius
Circle.Color = CircleColor
Circle.Thickness = 2
Circle.Transparency = 1
Circle.Filled = false
Circle.NumSides = 64  -- Make it smooth

-- Update circle position every frame to keep it centered
RunService.RenderStepped:Connect(function()
    if Camera then
        Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

-- ESP table to store drawings per player
local ESP_Drawings = {}

-- Function to create ESP for a player
local function CreateESP(Player)
    if Player == LocalPlayer or not Player.Character then return end
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(0, 255, 0)  -- Green box
    Box.Thickness = ESPThickness
    Box.Transparency = ESPTransparency
    Box.Filled = false
    
    local NameText = Drawing.new("Text")
    NameText.Visible = false
    NameText.Color = Color3.fromRGB(255, 255, 255)
    NameText.Size = 16
    NameText.Center = true
    NameText.Outline = true
    
    local HealthBar = Drawing.new("Line")
    HealthBar.Visible = false
    HealthBar.Color = Color3.fromRGB(255, 0, 0)  -- Red health bar
    HealthBar.Thickness = 2
    
    local DistanceText = Drawing.new("Text")
    DistanceText.Visible = false
    DistanceText.Color = Color3.fromRGB(255, 255, 0)
    DistanceText.Size = 14
    DistanceText.Center = true
    DistanceText.Outline = true
    
    ESP_Drawings[Player] = {
        Box = Box,
        Name = NameText,
        Health = HealthBar,
        Distance = DistanceText
    }
end

-- Function to update ESP
local function UpdateESP()
    for Player, Drawings in pairs(ESP_Drawings) do
        if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
            local RootPart = Player.Character.HumanoidRootPart
            local Humanoid = Player.Character.Humanoid
            local Head = Player.Character:FindFirstChild("Head")
            
            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude
            if Distance > MaxDistance then
                Drawings.Box.Visible = false
                Drawings.Name.Visible = false
                Drawings.Health.Visible = false
                Drawings.Distance.Visible = false
                continue
            end
            
            -- Get screen positions
            local _, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if not OnScreen then
                Drawings.Box.Visible = false
                Drawings.Name.Visible = false
                Drawings.Health.Visible = false
                Drawings.Distance.Visible = false
                continue
            end
            
            -- Calculate box size
            local Top = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 1, 0))
            local Bottom = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0))
            local Size = Vector2.new(math.abs(Top.X - Bottom.X) * 1.5, math.abs(Top.Y - Bottom.Y))
            
            Drawings.Box.Size = Size
            Drawings.Box.Position = Vector2.new(Top.X - Size.X / 2, Top.Y)
            Drawings.Box.Visible = true
            
            -- Make it "beautiful" with color based on health
            local HealthFraction = Humanoid.Health / Humanoid.MaxHealth
            Drawings.Box.Color = Color3.fromRGB(255 * (1 - HealthFraction), 255 * HealthFraction, 0)
            
            -- Name
            if ShowName and Head then
                local NamePos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 2, 0))
                Drawings.Name.Position = Vector2.new(NamePos.X, NamePos.Y - 20)
                Drawings.Name.Text = Player.Name
                Drawings.Name.Visible = true
            end
            
            -- Health bar
            if ShowHealth then
                Drawings.Health.From = Vector2.new(Drawings.Box.Position.X - 5, Drawings.Box.Position.Y + Drawings.Box.Size.Y)
                Drawings.Health.To = Vector2.new(Drawings.Health.From.X, Drawings.Health.From.Y - (Drawings.Box.Size.Y * HealthFraction))
                Drawings.Health.Color = Color3.fromRGB(255 * (1 - HealthFraction), 255 * HealthFraction, 0)
                Drawings.Health.Visible = true
            end
            
            -- Distance
            if ShowDistance then
                local DistPos = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 4, 0))
                Drawings.Distance.Position = Vector2.new(DistPos.X, DistPos.Y)
                Drawings.Distance.Text = math.floor(Distance) .. " studs"
                Drawings.Distance.Visible = true
            end
        else
            Drawings.Box.Visible = false
            Drawings.Name.Visible = false
            Drawings.Health.Visible = false
            Drawings.Distance.Visible = false
        end
    end
end

-- Add existing players
for _, Player in ipairs(Players:GetPlayers()) do
    CreateESP(Player)
end

-- Add new players
Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Wait()
    CreateESP(Player)
end)

-- Update loop
RunService.RenderStepped:Connect(UpdateESP)

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(Player)
    if ESP_Drawings[Player] then
        for _, Drawing in pairs(ESP_Drawings[Player]) do
            Drawing:Remove()
        end
        ESP_Drawings[Player] = nil
    end
end)

print("Script loaded: Fixed center circle and beautiful ESP for Rivals")
