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
frame.Size = UDim2.new(0, 260, 0, 340)
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
local noclipEnabled = false
local walkSpeedEnabled = false
local basePosition = nil
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESPFolder"

-- 🔍 ESP
local espBtn = createBtn("ESP: OFF", 50)
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

-- 🚫 Noclip
local noclipBtn = createBtn("Noclip: OFF", 90)
noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- 🏃 WalkSpeed
local wsBtn = createBtn("WalkSpeed: OFF", 130)
local wsBox = createBox(170, "Speed (e.g. 50)")

wsBtn.MouseButton1Click:Connect(function()
	walkSpeedEnabled = not walkSpeedEnabled
	wsBtn.Text = "WalkSpeed: " .. (walkSpeedEnabled and "ON" or "OFF")
	local speed = tonumber(wsBox.Text) or 16
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedEnabled and speed or 16
	end
end)

-- 📍 SetBase / TPBase
local setBtn = createBtn("📌 Set Base", 210)
local tpBtn = createBtn("🚀 TP to Base", 250)

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
