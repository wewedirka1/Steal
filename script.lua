-- // 🌟 GendioHub WATERMARK
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local wmGui = Instance.new("ScreenGui", CoreGui)
wmGui.Name = "GendioWatermark"

local wmFrame = Instance.new("Frame", wmGui)
wmFrame.Size = UDim2.new(0, 200, 0, 40)
wmFrame.Position = UDim2.new(0, 10, 0, 10)
wmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
wmFrame.BorderSizePixel = 0
wmFrame.BackgroundTransparency = 0.2
wmFrame.Active = true
wmFrame.Draggable = true

local UICorner = Instance.new("UICorner", wmFrame)
UICorner.CornerRadius = UDim.new(0, 6)

local wmTitle = Instance.new("TextLabel", wmFrame)
wmTitle.Text = "GendioHub"
wmTitle.Font = Enum.Font.GothamBold
wmTitle.TextSize = 18
wmTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
wmTitle.BackgroundTransparency = 1
wmTitle.Position = UDim2.new(0, 10, 0, 3)
wmTitle.Size = UDim2.new(0, 120, 0, 18)
wmTitle.TextXAlignment = Enum.TextXAlignment.Left

local wmInfo = Instance.new("TextLabel", wmFrame)
wmInfo.Text = "..."
wmInfo.Font = Enum.Font.Code
wmInfo.TextSize = 14
wmInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
wmInfo.BackgroundTransparency = 1
wmInfo.Position = UDim2.new(0, 10, 0, 20)
wmInfo.Size = UDim2.new(1, -20, 0, 15)
wmInfo.TextXAlignment = Enum.TextXAlignment.Left

-- Обновление watermark info (FPS + время)
local fps = 0
local lastTick = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	frameCount += 1
	if tick() - lastTick >= 1 then
		fps = frameCount
		frameCount = 0
		lastTick = tick()
		local hour = os.date("%H:%M:%S")
		wmInfo.Text = "FPS: " .. tostring(fps) .. "  |  Time: " .. hour
	end
end)

-- // 🔧 ФУНКЦИОНАЛ GUI
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GendioHubUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 420) -- Increased height to accommodate new button
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uicorner2 = Instance.new("UICorner", frame)
uicorner2.CornerRadius = UDim.new(0, 8)

local function createBtn(txt, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -20, 0, 35)
	b.Position = UDim2.new(0, 10, 0, y)
	b.Text = txt
	b.Font = Enum.Font.SourceSans
	b.TextSize = 20
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	local u = Instance.new("UICorner", b)
	u.CornerRadius = UDim.new(0, 6)
	return b
end

local function createLabel(txt, y)
	local l = Instance.new("TextLabel", frame)
	l.Size = UDim2.new(1, 0, 0, 25)
	l.Position = UDim2.new(0, 0, 0, y)
	l.Text = txt
	l.Font = Enum.Font.SourceSansBold
	l.TextSize = 20
	l.BackgroundTransparency = 1
	l.TextColor3 = Color3.new(1,1,1)
	return l
end

local function createBox(y, ph)
	local b = Instance.new("TextBox", frame)
	b.Size = UDim2.new(1, -20, 0, 30)
	b.Position = UDim2.new(0, 10, 0, y)
	b.PlaceholderText = ph
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 18
	b.ClearTextOnFocus = false
	local u = Instance.new("UICorner", b)
	u.CornerRadius = UDim.new(0, 6)
	return b
end

-- ✖ Закрытие
local close = createBtn("✖ Close", 10)
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ⚙️ Переменные
local espEnabled = false
local walkSpeedEnabled = false
local infinityJumpEnabled = false
local basePosition = nil
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESPFolder"
local platform = nil -- For LeavePlayer platform

-- Noclip (Moved to top)
local noclipBtn = createBtn("Noclip: OFF", 50)
local noclipLoaded = false

local noclipScript = [==[
-- 🌟 Noclip Bypass + Full Float (вверх/вниз)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SoftKillzFloatGui"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.7, 0, 0.55, 0)
frame.Size = UDim2.new(0, 180, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundTransparency = 1
title.Text = "Noclip Bypass"
title.TextColor3 = Color3.fromRGB(255, 0, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
noclipBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
noclipBtn.Text = "NoClip"
noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
noclipBtn.TextScaled = true
noclipBtn.Font = Enum.Font.SourceSansBold

local plusBtn = Instance.new("TextButton", frame)
plusBtn.Position = UDim2.new(0.5, 5, 0.35, 0)
plusBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.SourceSansBold

local minusBtn = Instance.new("TextButton", frame)
minusBtn.Position = UDim2.new(0.75, 5, 0.35, 0)
minusBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.SourceSansBold

local upBtn = Instance.new("TextButton", frame)
upBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
upBtn.Size = UDim2.new(0.425, 0, 0.25, 0)
upBtn.Text = "↑"
upBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
upBtn.TextScaled = true
upBtn.Font = Enum.Font.SourceSansBold

local downBtn = Instance.new("TextButton", frame)
downBtn.Position = UDim2.new(0.525, 0, 0.7, 0)
downBtn.Size = UDim2.new(0.425, 0, 0.25, 0)
downBtn.Text = "↓"
downBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
downBtn.TextScaled = true
downBtn.Font = Enum.Font.SourceSansBold

-- NoClip + Anti-Fall
local noclip = false
local floatVelocity, floatGyro, conn

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip

	if noclip then
		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)
		conn = RunService.Stepped:Connect(function()
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
		floatVelocity = Instance.new("BodyVelocity")
		floatVelocity.Velocity = Vector3.new(0, 0, 0)
		floatVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		floatVelocity.P = 100000
		floatVelocity.Parent = HumanoidRootPart
		floatGyro = Instance.new("BodyGyro")
		floatGyro.CFrame = HumanoidRootPart.CFrame
		floatGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		floatGyro.P = 3000
		floatGyro.Parent = HumanoidRootPart
	else
		if conn then conn:Disconnect() end
		if floatVelocity then floatVelocity:Destroy() end
		if floatGyro then floatGyro:Destroy() end
		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
	end
end)

local moveDistance = 4
plusBtn.MouseButton1Click:Connect(function()
	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector * moveDistance
end)
minusBtn.MouseButton1Click:Connect(function()
	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - HumanoidRootPart.CFrame.LookVector * moveDistance
end)
upBtn.MouseButton1Click:Connect(function()
	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, moveDistance, 0)
end)
downBtn.MouseButton1Click:Connect(function()
	HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - Vector3.new(0, moveDistance, 0)
end)
]==]

noclipBtn.MouseButton1Click:Connect(function()
	if not noclipLoaded then
		noclipLoaded = true
		noclipBtn.Text = "Noclip: ON"
		loadstring(noclipScript)()
	else
		noclipLoaded = false
		noclipBtn.Text = "Noclip: OFF"
	end
end)

-- 🔍 ESP
local espBtn = createBtn("ESP: OFF", 90)
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
	for _, c in pairs(espFolder:GetChildren()) do c:Destroy() end
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local b = Instance.new("BillboardGui", espFolder)
				b.Adornee = p.Character.Head
				b.Size = UDim2.new(0, 100, 0, 40)
				b.AlwaysOnTop = true
				b.StudsOffset = Vector3.new(0, 2, 0)
				local t = Instance.new("TextLabel", b)
				t.Size = UDim2.new(1, 0, 1, 0)
				t.BackgroundTransparency = 1
				t.Text = p.Name
				t.TextColor3 = Color3.fromRGB(0, 255, 0)
				t.TextScaled = true
				t.Font = Enum.Font.SourceSansBold
			end
		end
	end
end)

-- 🚀 Infinity Jump
local infJumpBtn = createBtn("Infinity Jump: OFF", 130)
local infJumpConnection = nil

infJumpBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infJumpBtn.Text = "Infinity Jump: " .. (infinityJumpEnabled and "ON" or "OFF")
	
	if infinityJumpEnabled then
		infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if infJumpConnection then
			infJumpConnection:Disconnect()
			infJumpConnection = nil
		end
	end
end)

-- 🏃 WalkSpeed
local wsBtn = createBtn("WalkSpeed: OFF", 170)
local wsBox = createBox(210, "Speed (e.g. 50)")

wsBtn.MouseButton1Click:Connect(function()
	walkSpeedEnabled = not walkSpeedEnabled
	wsBtn.Text = "WalkSpeed: " .. (walkSpeedEnabled and "ON" or "OFF")
	local speed = tonumber(wsBox.Text) or 16
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedEnabled and speed or 16
	end
end)

-- 📍 SetBase / TPBase
local setBtn = createBtn("📌 Set Base", 250)
local tpBtn = createBtn("🚀 TP to Base", 290)

setBtn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		basePosition = LocalPlayer.Character.HumanoidRootPart.Position
		setBtn.Text = "📌 Base Set!"
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition + Vector3.new(0, 5, 0))
	end
end)

-- ☁️ LeavePlayer
local leaveBtn = createBtn("☁️ LeavePlayer", 330)
leaveBtn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		-- Teleport player to sky (high Y position)
		local skyPosition = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Position.X, 1000, LocalPlayer.Character.HumanoidRootPart.Position.Z)
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(skyPosition + Vector3.new(0, 5, 0))
		
		-- Remove existing platform if any
		if platform then
			platform:Destroy()
		end
		
		-- Create a new platform
		platform = Instance.new("Part", workspace)
		platform.Size = Vector3.new(10, 1, 10)
		platform.Position = skyPosition
		platform.Anchored = true -- Prevents the platform from falling
		platform.BrickColor = BrickColor.new("Institutional white")
		platform.Material = Enum.Material.SmoothPlastic
		platform.CanCollide = true
	end
end)

-- Обновление walkspeed и infinity jump при респавне
LocalPlayer.CharacterAdded:Connect(function(character)
	wait(1)
	if walkSpeedEnabled then
		local humanoid = character:WaitForChild("Humanoid")
		local speed = tonumber(wsBox.Text) or 16
		humanoid.WalkSpeed = speed
	end
	if infinityJumpEnabled then
		infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end)
