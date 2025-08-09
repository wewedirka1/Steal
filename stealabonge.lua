-- GodMode Script for Garden Tower Defense (Roblox)
-- Inject via exploit

local player = game.Players.LocalPlayer
local godmode = false
local connection

-- Function to apply GodMode to character
local function applyGodMode(char)
    local humanoid = char:WaitForChild("Humanoid")
    
    if godmode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Remove hitboxes (disable collisions)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then  -- Don't disable root to avoid falling through floor
                part.CanCollide = false
            end
        end
        
        -- Prevent health from dropping
        if connection then connection:Disconnect() end
        connection = humanoid.HealthChanged:Connect(function(health)
            if health < math.huge then
                humanoid.Health = math.huge
            end
        end)
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        
        -- Restore hitboxes
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Handle current character
if player.Character then
    applyGodMode(player.Character)
end

-- Handle respawn
player.CharacterAdded:Connect(applyGodMode)

-- GUI Setup
local sg = Instance.new("ScreenGui")
sg.Parent = game.CoreGui  -- Use CoreGui for exploit visibility

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0, 50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = sg

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "GodMode (OFF)"
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
button.Parent = frame

button.MouseButton1Click:Connect(function()
    godmode = not godmode
    button.Text = "GodMode (" .. (godmode and "ON" or "OFF") .. ")"
    
    -- Apply to current character
    if player.Character then
        applyGodMode(player.Character)
    end
end)
