-- GodMode Script for Garden Tower Defense (Roblox)
-- Improved with error handling and debug output

local player = game.Players.LocalPlayer
local godmode = false
local connection

-- Function to apply GodMode
local function applyGodMode(char)
    if not char then
        warn("Error: Character not found!")
        return
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("Error: Humanoid not found in character!")
        return
    end
    
    if godmode then
        print("GodMode ON for", player.Name)
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Disable hitboxes (except HumanoidRootPart)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
        
        -- Prevent health drop
        if connection then connection:Disconnect() end
        connection = humanoid.HealthChanged:Connect(function(health)
            if health < math.huge then
                humanoid.Health = math.huge
            end
        end)
    else
        print("GodMode OFF for", player.Name)
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

-- Wait for character to load
local function waitForCharacter()
    while not player.Character do
        wait(0.5)
        print("Waiting for character to load...")
    end
    print("Character loaded, applying GodMode settings")
    applyGodMode(player.Character)
end

-- Initial character check
if player.Character then
    applyGodMode(player.Character)
else
    waitForCharacter()
end

-- Handle respawn
player.CharacterAdded:Connect(function(char)
    print("Character respawned, reapplying GodMode")
    applyGodMode(char)
end)

-- GUI Setup
if not game.CoreGui then
    warn("Error: CoreGui not accessible! Check exploit compatibility.")
    return
end

local sg = Instance.new("ScreenGui")
sg.Name = "GodModeGUI"
sg.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.1, 0)
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
    print("GodMode toggled to", godmode and "ON" or "OFF")
    
    -- Apply to current character
    if player.Character then
        applyGodMode(player.Character)
    else
        warn("No character found, waiting for respawn")
    end
end)

print("GodMode script loaded successfully!")
