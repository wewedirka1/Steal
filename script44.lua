-- Roblox Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Variables for functions
local noclipToggle = false
local walkSpeedToggle = false
local espToggle = false
local infiniteJumpToggle = false
local antiCheatToggle = false
local savedPosition = nil
local guiVisible = true

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GendioHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame with improved background
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- Dark blue background
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Circular opening animation
local circle = Instance.new("Frame")
circle.Size = UDim2.new(0, 0, 0, 0)
circle.Position = UDim2.new(0.5, -50, 0.5, -50)
circle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
circle.BorderSizePixel = 0
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circle
circle.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GH"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 40
titleLabel.Parent = circle

-- Opening animation
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(circle, tweenInfo, {Size = UDim2.new(0, 100, 0, 100)})
tween:Play()
tween.Completed:Connect(function()
    mainFrame.BackgroundTransparency = 0.1
    circle.Visible = false
end)

-- Rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- Background texture (light pattern)
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://2592368600" -- Light pattern
backgroundImage.ImageTransparency = 0.8
backgroundImage.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🍎 Gendio Hub"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextStrokeTransparency = 0.3
title.Parent = mainFrame

-- Tabs
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local movementTabBtn = Instance.new("TextButton")
movementTabBtn.Size = UDim2.new(0.5, 0, 0, 40)
movementTabBtn.Position = UDim2.new(0, 0, 0, 0)
movementTabBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
local tabGradient = Instance.new("UIGradient")
tabGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 90, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 60, 90))
}
tabGradient.Parent = movementTabBtn
movementTabBtn.Text = "Movement"
movementTabBtn.TextColor3 = Color3.fromRGB(230, 230, 255)
movementTabBtn.Font = Enum.Font.Gotham
movementTabBtn.TextSize = 16
local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 10)
btnCorner1.Parent = movementTabBtn
local btnStroke1 = Instance.new("UIStroke")
btnStroke1.Thickness = 1
btnStroke1.Color = Color3.fromRGB(60, 80, 110)
btnStroke1.Parent = movementTabBtn
movementTabBtn.Parent = tabContainer

local otherTabBtn = Instance.new("TextButton")
otherTabBtn.Size = UDim2.new(0.5, 0, 0, 40)
otherTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
otherTabBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
local tabGradient2 = Instance.new("UIGradient")
tabGradient2.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 90, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 60, 90))
}
tabGradient2.Parent = otherTabBtn
otherTabBtn.Text = "Other"
otherTabBtn.TextColor3 = Color3.fromRGB(230, 230, 255)
otherTabBtn.Font = Enum.Font.Gotham
otherTabBtn.TextSize = 16
local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 10)
btnCorner2.Parent = otherTabBtn
local btnStroke2 = Instance.new("UIStroke")
btnStroke2.Thickness = 1
btnStroke2.Color = Color3.fromRGB(60, 80, 110)
btnStroke2.Parent = otherTabBtn
otherTabBtn.Parent = tabContainer

-- Tab frames
local movementFrame = Instance.new("Frame")
movementFrame.Size = UDim2.new(1, 0, 0, 310)
movementFrame.Position = UDim2.new(0, 0, 0, 90)
movementFrame.BackgroundTransparency = 1
movementFrame.Visible = true
movementFrame.Parent = mainFrame

local otherFrame = Instance.new("Frame")
otherFrame.Size = UDim2.new(1, 0, 0, 310)
otherFrame.Position = UDim2.new(0, 0, 0, 90)
otherFrame.BackgroundTransparency = 1
otherFrame.Visible = false
otherFrame.Parent = mainFrame

-- Function to create toggle buttons
local function createToggle(name, posY, parentFrame, callback)
    if not parentFrame then return end
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 50)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundTransparency = 1
    container.Parent = parentFrame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.7, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = Color3.fromRGB(200, 200, 255)
    text.Font = Enum.Font.Gotham
    text.TextSize = 18
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 40)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 110)
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 100, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 70, 100))
    }
    btnGradient.Parent = toggleBtn
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 16
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleBtn
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(70, 90, 120)
    btnStroke.Parent = toggleBtn
    toggleBtn.Parent = container

    toggleBtn.MouseButton1Click:Connect(function()
        if not callback then return end
        callback(toggleBtn.Text == "OFF")
        toggleBtn.Text = toggleBtn.Text == "OFF" and "ON" or "OFF"
        toggleBtn.TextColor3 = toggleBtn.Text == "ON" and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        local newGradient = toggleBtn.Text == "ON" and ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 100, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 80, 30))
        } or ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 100, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 70, 100))
        }
        btnGradient.Color = newGradient
    end)

    return toggleBtn
end

-- Function to create buttons
local function createButton(name, posY, parentFrame, callback)
    if not parentFrame then return end
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = UDim2.new(0, 10, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(60, 80, 110)
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 100, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 70, 100))
    }
    btnGradient.Parent = button
    button.Text = name
    button.TextColor3 = Color3.fromRGB(230, 230, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = button
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(70, 90, 120)
    btnStroke.Parent = button
    button.Parent = parentFrame

    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- Tab switching
movementTabBtn.MouseButton1Click:Connect(function()
    movementFrame.Visible = true
    otherFrame.Visible = false
    movementTabBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 120)
    otherTabBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
end)

otherTabBtn.MouseButton1Click:Connect(function()
    movementFrame.Visible = false
    otherFrame.Visible = true
    movementTabBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
    otherTabBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 120)
end)

-- Mobile toggle icon for opening/closing GUI
local toggleIcon = Instance.new("TextButton")
toggleIcon.Size = UDim2.new(0, 60, 0, 60)
toggleIcon.Position = UDim2.new(0.95, -30, 0.5, -30) -- Right side, vertical center
toggleIcon.BackgroundColor3 = Color3.fromRGB(60, 80, 110)
local iconGradient = Instance.new("UIGradient")
iconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 100, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 70, 100))
}
iconGradient.Parent = toggleIcon
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = toggleIcon
local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 2
iconStroke.Color = Color3.fromRGB(70, 90, 120)
iconStroke.Parent = toggleIcon
toggleIcon.Text = "GH"
toggleIcon.TextColor3 = Color3.fromRGB(230, 230, 255)
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.TextSize = 24
toggleIcon.Parent = screenGui
toggleIcon.Active = true
toggleIcon.Draggable = true

toggleIcon.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    toggleIcon.Text = guiVisible and "GH" or "☰"
    toggleIcon.TextColor3 = guiVisible and Color3.fromRGB(230, 230, 255) or Color3.fromRGB(150, 255, 150)
end)

-- NoClip
local noclipToggleBtn = createToggle("NoClip", 10, movementFrame, function(value)
    noclipToggle = value
    if noclipToggle and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not value
            end
        end
    end
end)
RunService.Stepped:Connect(function()
    if noclipToggle and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- WalkSpeed
local walkSpeedToggleBtn = createToggle("WalkSpeed (50)", 70, movementFrame, function(value)
    walkSpeedToggle = value
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = value and 50 or 16
    end
end)

-- Infinite Jump
local infiniteJumpToggleBtn = createToggle("Infinite Jump", 130, movementFrame, function(value)
    infiniteJumpToggle = value
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpToggle and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- AntiCheat Disabler
local antiCheatToggleBtn = createToggle("AntiCheat Disabler", 10, otherFrame, function(value)
    antiCheatToggle = value
    if antiCheatToggle and player.Character then
        local success, err = pcall(function()
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local thirdPartyUserService = game:GetService("thirdPartyUserService") or nil
                if thirdPartyUserService then
                    local oldWalkSpeed = humanoid.WalkSpeed
                    local oldJumpPower = humanoid.JumpPower
                    humanoid.WalkSpeed = oldWalkSpeed
                    humanoid.JumpPower = oldJumpPower
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            pcall(function() part:SetNetworkOwner(nil) end)
                        end
                    end
                    for _, script in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if script:IsA("Script") and script.Name:lower():match("anti") then
                            script.Disabled = true
                        end
                    end
                else
                    warn("thirdPartyUserService not found, skipping advanced anti-cheat bypass.")
                end
            end
        end)
        if not success then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Failed to disable anti-cheat: " .. (err or "Unknown error"),
                Duration = 5
            })
        end
    else
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end)

-- ESP
local espToggleBtn = createToggle("ESP", 70, otherFrame, function(value)
    espToggle = value
    if espToggle then
        if not workspace then return end
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = v
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = v
            end
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():match("fruit") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = v
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = v
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") then
                v:Destroy()
            end
        end
    end
end)

-- Set Base
createButton("Set Base", 130, otherFrame, function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = player.Character.HumanoidRootPart.Position
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Base Set",
            Text = "Base position saved!",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Character not found!",
            Duration = 3
        })
    end
end)

-- Teleport to Saved Base
createButton("Teleport to Saved Base", 190, otherFrame, function()
    if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleported",
            Text = "Teleported to saved base!",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "No saved position or character not found!",
            Duration = 3
        })
    end
end)

-- Styling GUI
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
}
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(50, 70, 90)
uiStroke.Parent = mainFrame

-- Load notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Gendio Hub Loaded",
    Text = "Script loaded successfully! Use at your own risk.",
    Duration = 5
})
