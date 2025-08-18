--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local ContextActionService = game:GetService('ContextActionService')
local Phantom = false

local function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))

local Players = game:GetService('Players')
local Player = Players.LocalPlayer


local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Tornado_Time = tick()

local UserInputService = game:GetService('UserInputService')
local Last_Input = UserInputService:GetLastInputType()

local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')

local Vector2_Mouse_Location = nil
local Grab_Parry = nil

local Remotes = {}
local Parry_Key = nil
local Speed_Divisor_Multiplier = 1.1
local LobbyAP_Speed_Divisor_Multiplier = 1.1
local firstParryFired = false
local ParryThreshold = 2.5
local firstParryType = 'F_Key'
local Previous_Positions = {}
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualInputService = game:GetService("VirtualInputManager")


local GuiService = game:GetService('GuiService')

local function updateNavigation(guiObject: GuiObject | nil)
    GuiService.SelectedObject = guiObject
end

local function performFirstPress(parryType)
    if parryType == 'F_Key' then
        VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    elseif parryType == 'Left_Click' then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    elseif parryType == 'Navigation' then
        local button = Players.LocalPlayer.PlayerGui.Hotbar.Block
        updateNavigation(button)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.01)
        updateNavigation(nil)
    end
end

if not LPH_OBFUSCATED then
    function LPH_JIT(Function) return Function end
    function LPH_JIT_MAX(Function) return Function end
    function LPH_NO_VIRTUALIZE(Function) return Function end
end

local PropertyChangeOrder = {}

local HashOne
local HashTwo
local HashThree

LPH_NO_VIRTUALIZE(function()
    for Index, Value in next, getgc() do
        if rawequal(typeof(Value), "function") and islclosure(Value) and getrenv().debug.info(Value, "s"):find("SwordsController") then
            if rawequal(getrenv().debug.info(Value, "l"), 276) then
                HashOne = getconstant(Value, 62)
                HashTwo = getconstant(Value, 64)
                HashThree = getconstant(Value, 65)
            end
        end 
    end
end)()


LPH_NO_VIRTUALIZE(function()
    for Index, Object in next, game:GetDescendants() do
        if Object:IsA("RemoteEvent") and string.find(Object.Name, "\n") then
            Object.Changed:Once(function()
                table.insert(PropertyChangeOrder, Object)
            end)
        end
    end
end)()


repeat
    task.wait()
until #PropertyChangeOrder == 3


local ShouldPlayerJump = PropertyChangeOrder[1]
local MainRemote = PropertyChangeOrder[2]
local GetOpponentPosition = PropertyChangeOrder[3]

local Parry_Key

for Index, Value in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Block.Activated)) do
    if Value and Value.Function and not iscclosure(Value.Function)  then
        for Index2,Value2 in pairs(getupvalues(Value.Function)) do
            if type(Value2) == "function" then
                Parry_Key = getupvalue(getupvalue(Value2, 2), 17);
            end;
        end;
    end;
end;

local function Parry(...)
    ShouldPlayerJump:FireServer(HashOne, Parry_Key, ...)
    MainRemote:FireServer(HashTwo, Parry_Key, ...)
    GetOpponentPosition:FireServer(HashThree, Parry_Key, ...)
end

local Parries = 0

function create_animation(object, info, value)
    local animation = game:GetService('TweenService'):Create(object, info, value)

    animation:Play()
    task.wait(info.Time)

    Debris:AddItem(animation, 0)

    animation:Destroy()
    animation = nil
end

local Animation = {}
Animation.storage = {}

Animation.current = nil
Animation.track = nil

for _, v in pairs(game:GetService("ReplicatedStorage").Misc.Emotes:GetChildren()) do
    if v:IsA("Animation") and v:GetAttribute("EmoteName") then
        local Emote_Name = v:GetAttribute("EmoteName")
        Animation.storage[Emote_Name] = v
    end
end

local Emotes_Data = {}

for Object in pairs(Animation.storage) do
    table.insert(Emotes_Data, Object)
end

table.sort(Emotes_Data)

local Auto_Parry = {}

function Auto_Parry.Parry_Animation()
    local Parry_Animation = game:GetService("ReplicatedStorage").Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Player.Character:GetAttribute('CurrentlyEquippedSword')

    if not Current_Sword then
        return
    end

    if not Parry_Animation then
        return
    end

    local Sword_Data = game:GetService("ReplicatedStorage").Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)

    if not Sword_Data or not Sword_Data['AnimationType'] then
        return
    end

    for _, object in pairs(game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection:GetChildren()) do
        if object.Name == Sword_Data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local sword_animation_type = 'GrabParry'

                if object:FindFirstChild('Grab') then
                    sword_animation_type = 'Grab'
                end

                Parry_Animation = object[sword_animation_type]
            end
        end
    end

    Grab_Parry = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
    Grab_Parry:Play()
end

function Auto_Parry.Play_Animation(v)
    local Animations = Animation.storage[v]

    if not Animations then
        return false
    end

    local Animator = Player.Character.Humanoid.Animator

    if Animation.track then
        Animation.track:Stop()
    end

    Animation.track = Animator:LoadAnimation(Animations)
    Animation.track:Play()

    Animation.current = v
end

function Auto_Parry.Get_Balls()
    local Balls = {}

    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            table.insert(Balls, Instance)
        end
    end
    return Balls
end

function Auto_Parry.Get_Ball()
    for _, Instance in pairs(workspace.Balls:GetChildren()) do
        if Instance:GetAttribute('realBall') then
            Instance.CanCollide = false
            return Instance
        end
    end
end

function Auto_Parry.Lobby_Balls()
    for _, Instance in pairs(workspace.TrainingBalls:GetChildren()) do
        if Instance:GetAttribute("realBall") then
            return Instance
        end
    end
end


local Closest_Entity = nil

function Auto_Parry.Closest_Player()
    local Max_Distance = math.huge
    local Found_Entity = nil
    
    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(Player) then
            if Entity.PrimaryPart then  -- Check if PrimaryPart exists
                local Distance = Player:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance = Distance
                    Found_Entity = Entity
                end
            end
        end
    end
    
    Closest_Entity = Found_Entity
    return Found_Entity
end

function Auto_Parry:Get_Entity_Properties()
    Auto_Parry.Closest_Player()

    if not Closest_Entity then
        return false
    end

    local Entity_Velocity = Closest_Entity.PrimaryPart.Velocity
    local Entity_Direction = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local Entity_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude

    return {
        Velocity = Entity_Velocity,
        Direction = Entity_Direction,
        Distance = Entity_Distance
    }
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled


function Auto_Parry.Parry_Data(Parry_Type)
    Auto_Parry.Closest_Player()
    
    local Events = {}
    local Camera = workspace.CurrentCamera
    local Vector2_Mouse_Location
    
    if Last_Input == Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or Last_Input == Enum.UserInputType.Keyboard) then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    if isMobile then
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end
    
    local Players_Screen_Positions = {}
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= Player.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
            
            if isOnScreen then
                Players_Screen_Positions[v] = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            Events[tostring(v)] = screenPos
        end
    end
    
    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Straight' then
        local Aimed_Player = nil
        local Closest_Distance = math.huge
        local Mouse_Vector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])
        
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character then
                local worldPos = v.PrimaryPart.Position
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)
                
                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (Mouse_Vector - playerScreenPos).Magnitude
                    
                    if distance < Closest_Distance then
                        Closest_Distance = distance
                        Aimed_Player = v
                    end
                end
            end
        end
        
        if Aimed_Player then
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Aimed_Player.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        else
            return {0, CFrame.new(Player.Character.PrimaryPart.Position, Closest_Entity.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        end
    end
    
    if Parry_Type == 'Random' then
        return {0, CFrame.new(Camera.CFrame.Position, Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'High' then
        local High_Direction = Camera.CFrame.UpVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + High_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Left' then
        local Left_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Left_Direction), Events, Vector2_Mouse_Location}
    end
    
    if Parry_Type == 'Right' then
        local Right_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Right_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'RandomTarget' then
        local candidates = {}
        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= Player.Character and v.PrimaryPart then
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                if isOnScreen then
                    table.insert(candidates, {
                        character = v,
                        screenXY  = { screenPos.X, screenPos.Y }
                    })
                end
            end
        end
        if #candidates > 0 then
            local pick = candidates[ math.random(1, #candidates) ]
            local lookCFrame = CFrame.new(Player.Character.PrimaryPart.Position, pick.character.PrimaryPart.Position)
            return {0, lookCFrame, Events, pick.screenXY}
        else
            return {0, Camera.CFrame, Events, { Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 }}
        end
    end
    
    return Parry_Type
end

function Auto_Parry.Parry(Parry_Type)
    local Parry_Data = Auto_Parry.Parry_Data(Parry_Type)

    if not firstParryFired then
        performFirstPress(firstParryType)
        firstParryFired = true
    else
        Parry(Parry_Data[1], Parry_Data[2], Parry_Data[3], Parry_Data[4])
    end

    if Parries > 7 then
        return false
    end

    Parries += 1

    task.delay(0.5, function()
        if Parries > 0 then
            Parries -= 1
        end
    end)
end

local Lerp_Radians = 0
local Last_Warping = tick()

function Auto_Parry.Linear_Interpolation(a, b, time_volume)
    return a + (b - a) * time_volume
end

local Previous_Velocity = {}
local Curving = tick()

local Runtime = workspace.Runtime


function Auto_Parry.Is_Curved()
    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return false
    end

    local Zoomies = Ball:FindFirstChild('zoomies')

    if not Zoomies then
        return false
    end

    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)

    local Speed = Velocity.Magnitude
    local Speed_Threshold = math.min(Speed / 100, 40)

    local Direction_Difference = (Ball_Direction - Velocity).Unit
    local Direction_Similarity = Direction:Dot(Direction_Difference)

    local Dot_Difference = Dot - Direction_Similarity
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude

    local Pings = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

    local Dot_Threshold = 0.5 - (Pings / 1000)
    local Reach_Time = Distance / Speed - (Pings / 1000)

    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold

    local Clamped_Dot = math.clamp(Dot, -1, 1)
    local Radians = math.rad(math.asin(Clamped_Dot))

    Lerp_Radians = Auto_Parry.Linear_Interpolation(Lerp_Radians, Radians, 0.8)

    if Speed > 100 and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if Distance < Ball_Distance_Threshold then
        return false
    end

    if Dot_Difference < Dot_Threshold then
        return true
    end

    if Lerp_Radians < 0.018 then
        Last_Warping = tick()
    end

    if (tick() - Last_Warping) < (Reach_Time / 1.5) then
        return true
    end

    if (tick() - Curving) < (Reach_Time / 1.5) then
        return true
    end

    return Dot < Dot_Threshold
end

function Auto_Parry:Get_Ball_Properties()
    local Ball = Auto_Parry.Get_Ball()

    local Ball_Velocity = Vector3.zero
    local Ball_Origin = Ball

    local Ball_Direction = (Player.Character.PrimaryPart.Position - Ball_Origin.Position).Unit
    local Ball_Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Ball_Dot = Ball_Direction:Dot(Ball_Velocity.Unit)

    return {
        Velocity = Ball_Velocity,
        Direction = Ball_Direction,
        Distance = Ball_Distance,
        Dot = Ball_Dot
    }
end

function Auto_Parry.Spam_Service(self)
    local Ball = Auto_Parry.Get_Ball()

    local Entity = Auto_Parry.Closest_Player()

    if not Ball then
        return false
    end

    if not Entity or not Entity.PrimaryPart then
        return false
    end

    local Spam_Accuracy = 0

    local Velocity = Ball.AssemblyLinearVelocity
    local Speed = Velocity.Magnitude

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Velocity.Unit)

    local Target_Position = Entity.PrimaryPart.Position
    local Target_Distance = Player:DistanceFromCharacter(Target_Position)

    local Maximum_Spam_Distance = self.Ping + math.min(Speed / 6, 95)

    if self.Entity_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if self.Ball_Properties.Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    if Target_Distance > Maximum_Spam_Distance then
        return Spam_Accuracy
    end

    local Maximum_Speed = 5 - math.min(Speed / 5, 5)
    local Maximum_Dot = math.clamp(Dot, -1, 0) * Maximum_Speed

    Spam_Accuracy = Maximum_Spam_Distance - Maximum_Dot

    return Spam_Accuracy
end

local Connections_Manager = {}
local Selected_Parry_Type = "Camera"

local Infinity = false

ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    if b then
        Infinity = true
    else
        Infinity = false
    end
end)

local Parried = false
local Last_Parry = 0


local AutoParry = true

local Balls = workspace:WaitForChild('Balls')
local CurrentBall = nil
local InputTask = nil
local Cooldown = 0.02
local RunTime = workspace:FindFirstChild("Runtime")



local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:FindFirstChild("ff") then
            return Ball
        end
    end
    return nil
end

local function SpamInput(Label)
    if InputTask then return end
    InputTask = task.spawn(function()
        while AutoParry do
            Auto_Parry.Parry(Selected_Parry_Type)
            task.wait(Cooldown)
        end
        InputTask = nil
    end)
end

Balls.ChildAdded:Connect(function(Value)
    Value.ChildAdded:Connect(function(Child)
        if getgenv().SlashOfFuryDetection and Child.Name == 'ComboCounter' then
            local Sof_Label = Child:FindFirstChildOfClass('TextLabel')

            if Sof_Label then
                repeat
                    local Slashes_Counter = tonumber(Sof_Label.Text)

                    if Slashes_Counter and Slashes_Counter < 32 then
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end

                    task.wait()

                until not Sof_Label.Parent or not Sof_Label
            end
        end
    end)
end)

local player10239123 = Players.LocalPlayer

RunTime.ChildAdded:Connect(function(Object)
    local Name = Object.Name
    if getgenv().PhantomV2Detection then
        if Name == "maxTransmission" or Name == "transmissionpart" then
            local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Character = player10239123.Character or player10239123.CharacterAdded:Wait()
                if Character and Weld.Part1 == Character.HumanoidRootPart then
                    CurrentBall = GetBall()
                    Weld:Destroy()
    
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection = RunService.RenderStepped:Connect(function()
                            local Highlighted = CurrentBall:GetAttribute("highlighted")
    
                            if Highlighted == true then
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
    
                                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                                if HumanoidRootPart then
                                    local PlayerPosition = HumanoidRootPart.Position
                                    local BallPosition = CurrentBall.Position
                                    local PlayerToBall = (BallPosition - PlayerPosition).Unit
    
                                    game.Players.LocalPlayer.Character.Humanoid:Move(PlayerToBall, false)
                                end
    
                            elseif Highlighted == false then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
    
                                task.delay(3, function()
                                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                end)
    
                                CurrentBall = nil
                            end
                        end)
    
                        task.delay(3, function()
                            if FocusConnection and FocusConnection.Connected then
                                FocusConnection:Disconnect()
    
                                game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, 0), false)
                                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                CurrentBall = nil
                            end
                        end)
                    end
                end
            end
        end
    end
end)

local player11 = game.Players.LocalPlayer
local PlayerGui = player11:WaitForChild("PlayerGui")
local playerGui = player11:WaitForChild("PlayerGui")
local Hotbar = PlayerGui:WaitForChild("Hotbar")


local ParryCD = playerGui.Hotbar.Block.UIGradient
local AbilityCD = playerGui.Hotbar.Ability.UIGradient

local function isCooldownInEffect1(uigradient)
    return uigradient.Offset.Y < 0.4
end

local function isCooldownInEffect2(uigradient)
    return uigradient.Offset.Y == 0.5
end

local function cooldownProtection()
    if isCooldownInEffect1(ParryCD) then
        game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
        return true
    end
    return false
end

local function AutoAbility()
    if isCooldownInEffect2(AbilityCD) then
        if Player.Character.Abilities["Raging Deflection"].Enabled or Player.Character.Abilities["Rapture"].Enabled or Player.Character.Abilities["Calming Deflection"].Enabled or Player.Character.Abilities["Aerodynamic Slash"].Enabled or Player.Character.Abilities["Fracture"].Enabled or Player.Character.Abilities["Death Slash"].Enabled then
            Parried = true
            game:GetService("ReplicatedStorage").Remotes.AbilityButtonPress:Fire()
            task.wait(2.432)
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
            return true
        end
    end
    return false
end

local Airflow = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))();

local Window = Airflow:Init({
	Name = "Celestia",
	Keybind = "LeftControl",
	Logo = "http://www.roblox.com/asset/?id=94220348785476",
});

local Blatant = Window:DrawTab({
	Name = "Blatant",
	Icon = "sword"
})

local player = Window:DrawTab({
	Name = "Player",
	Icon = "user"
})

local world = Window:DrawTab({
	Name = "World",
	Icon = "globe"
})

local farm = Window:DrawTab({
	Name = "Farm",
	Icon = "wrap-text"
})

local misc = Window:DrawTab({
	Name = "Misc",
	Icon = "layers"
})

local module = Blatant:AddSection({
	Name = "Auto Parry",
	Position = "left",
});

module:AddToggle({
	Name = "Auto Parry",
	Callback = function(value)
        if value then
            Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
                local One_Ball = Auto_Parry.Get_Ball()
                local Balls = Auto_Parry.Get_Balls()

                for _, Ball in pairs(Balls) do

                    if not Ball then
                        return
                    end

                    local Zoomies = Ball:FindFirstChild('zoomies')
                    if not Zoomies then
                        return
                    end

                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        Parried = false
                    end)

                    if Parried then
                        return
                    end

                    local Ball_Target = Ball:GetAttribute('target')
                    local One_Target = One_Ball:GetAttribute('target')

                    local Velocity = Zoomies.VectorVelocity

                    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude

                    local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10

                    local Ping_Threshold = math.clamp(Ping / 10, 5, 17)

                    local Speed = Velocity.Magnitude

                    local cappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                    local speed_divisor_base = 2.4 + cappedSpeedDiff * 0.002

                    local effectiveMultiplier = Speed_Divisor_Multiplier
                    if getgenv().RandomParryAccuracyEnabled then
                        if Speed < 200 then
                            effectiveMultiplier = 0.7 + (math.random(40, 100) - 1) * (0.35 / 99)
                        else
                            effectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                        end
                    end

                    local speed_divisor = speed_divisor_base * effectiveMultiplier
                    local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5)

                    local Curved = Auto_Parry.Is_Curved()


                    if Phantom and Player.Character:FindFirstChild('ParryHighlight') and getgenv().PhantomV2Detection then
                    --Controls:Disable()

                ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)

                    Player.Character.Humanoid.WalkSpeed = 36
                    Player.Character.Humanoid:MoveTo(Ball.Position)

                    task.spawn(function()
                        repeat
                            if Player.Character.Humanoid.WalkSpeed ~= 36 then
                                Player.Character.Humanoid.WalkSpeed = 36
                            end

                            task.wait()

                        until not Phantom
                    end)

                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        --Controls:Enable()

                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        Phantom = false

                        Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
                        Player.Character.Humanoid.WalkSpeed = 10

                        task.delay(3, function()
                            Player.Character.Humanoid.WalkSpeed = 36
                        end)
                    end)
                end

                if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy and Phantom then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)

                    Parried = true
                end

                    if Ball:FindFirstChild('AeroDynamicSlashVFX') then
                        Debris:AddItem(Ball.AeroDynamicSlashVFX, 0)
                        Tornado_Time = tick()
                    end

                    if Runtime:FindFirstChild('Tornado') then
                        if (tick() - Tornado_Time) < (Runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
                        return
                        end
                    end

                    if One_Target == tostring(Player) and Curved then
                        return
                    end

                    if Ball:FindFirstChild("ComboCounter") then
                        return
                    end

                    local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
                    if Singularity_Cape then
                        return
                    end 

                    if getgenv().InfinityDetection and Infinity then
                        return
                    end

                    if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                        if getgenv().AutoAbility and AutoAbility() then
                            return
                        end
                    end

                    if Ball_Target == tostring(Player) and Distance <= Parry_Accuracy then
                        if getgenv().CooldownProtection and cooldownProtection() then
                            return
                        end

                        local Parry_Time = os.clock()
                        local Time_View = Parry_Time - (Last_Parry)
                        if Time_View > 0.5 then
                            Auto_Parry.Parry_Animation()
                        end

                        if getgenv().AutoParryKeypress then
                            VirtualInputService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
                        else
                            Auto_Parry.Parry(Selected_Parry_Type)
                        end

                        Last_Parry = Parry_Time
                        Parried = true
                    end
                    local Last_Parrys = tick()
                    repeat
                        RunService.PreSimulation:Wait()
                    until (tick() - Last_Parrys) >= 1 or not Parried
                    Parried = false
                end
            end)
        else
            if Connections_Manager['Auto Parry'] then
                Connections_Manager['Auto Parry']:Disconnect()
                Connections_Manager['Auto Parry'] = nil
            end
        end
    end
})

module:AddSlider({
	Name = "Parry Accuracy",
	Min = 1,
	Max = 100,
	Default = 100, -- optional, defaults to Min if not set
	Callback = function(value)
		Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.35 / 99)
	end
})

local parryTypeMap = {
    ["Camera"] = "Camera",
    ["Random"] = "Random",
    ["Backwards"] = "Backwards",
    ["Straight"] = "Straight",
    ["High"] = "High",
    ["Left"] = "Left",
    ["Right"] = "Right",
    ["Random Target"] = "RandomTarget"
}

module:AddDropdown({
	Name = "Curve Type",
	Values = {
        "Camera",
        "Random",
        "Backwards",
        'Straight',
        'High',
        'Left',
        'Right',
        'Random Target'
    },
	Multi = false,
	Default = "Camera",
	Callback = function(value)
        Selected_Parry_Type = parryTypeMap[value] or value
    end
})

module:AddToggle({
	Name = "Random Parry Accuracy",
	Callback = function(value)
        getgenv().RandomParryAccuracyEnabled = value
    end
})

module:AddToggle({
	Name = "Infinity Detection",
	Callback = function(value)
        getgenv().InfinityDetection = value
    end
})

module:AddToggle({
	Name = "Keypress",
	Callback = function(value)
        getgenv().AutoParryKeypress = value
    end
})

local SpamParry = Blatant:AddSection({
	Name = "Auto Spam Parry",
	Position = "right",
});

SpamParry:AddToggle({
	Name = "Auto Spam Parry",
	Callback = function(value)
        if value then
            Connections_Manager['Auto Spam'] = RunService.PreSimulation:Connect(function()
                local Ball = Auto_Parry.Get_Ball()

                if not Ball then
                    return
                end

                local Zoomies = Ball:FindFirstChild('zoomies')

                if not Zoomies then
                    return
                end

                Auto_Parry.Closest_Player()

                local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

                local Ping_Threshold = math.clamp(Ping / 10, 1, 16)

                local Ball_Target = Ball:GetAttribute('target')

                local Ball_Properties = Auto_Parry:Get_Ball_Properties()
                local Entity_Properties = Auto_Parry:Get_Entity_Properties()

                local Spam_Accuracy = Auto_Parry.Spam_Service({
                    Ball_Properties = Ball_Properties,
                    Entity_Properties = Entity_Properties,
                    Ping = Ping_Threshold
                })

                local Target_Position = Closest_Entity.PrimaryPart.Position
                local Target_Distance = Player:DistanceFromCharacter(Target_Position)

                local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
                local Ball_Direction = Zoomies.VectorVelocity.Unit

                local Dot = Direction:Dot(Ball_Direction)

                local Distance = Player:DistanceFromCharacter(Ball.Position)

                if not Ball_Target then
                    return
                end

                if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then
                    return
                end
                
                local Pulsed = Player.Character:GetAttribute('Pulsed')

                if Pulsed then
                    return
                end

                if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then
                    return
                end

                local threshold = ParryThreshold

                if Distance <= Spam_Accuracy and Parries > threshold then
                    if getgenv().SpamParryKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                end
            end)
        else
            if Connections_Manager['Auto Spam'] then
                Connections_Manager['Auto Spam']:Disconnect()
                Connections_Manager['Auto Spam'] = nil
            end
        end
    end
})

SpamParry:AddDropdown({
	Name = "Parry Type",
	Values = {
        'Legit',
        'Blatant'
    },
	Multi = false,
	Default = "Legit",
	Callback = function(value)

    end
})

SpamParry:AddSlider({
	Name = "Parry Threshold",
	Min = 1,
	Max = 3,
	Default = 2.5, -- optional, defaults to Min if not set
	Callback = function(value)
		ParryThreshold = value
	end
})

if not isMobile then
    SpamParry:AddToggle({
        Name = "Animation Fix",
        Callback = function(value)
            if value then
                Connections_Manager['Animation Fix'] = RunService.PreSimulation:Connect(function()
                    local Ball = Auto_Parry.Get_Ball()

                    if not Ball then
                        return
                    end

                    local Zoomies = Ball:FindFirstChild('zoomies')

                    if not Zoomies then
                        return
                    end

                    Auto_Parry.Closest_Player()

                    local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

                    local Ping_Threshold = math.clamp(Ping / 10, 10, 16)

                    local Ball_Target = Ball:GetAttribute('target')

                    local Ball_Properties = Auto_Parry:Get_Ball_Properties()
                    local Entity_Properties = Auto_Parry:Get_Entity_Properties()

                    local Spam_Accuracy = Auto_Parry.Spam_Service({
                        Ball_Properties = Ball_Properties,
                        Entity_Properties = Entity_Properties,
                        Ping = Ping_Threshold
                    })

                    local Target_Position = Closest_Entity.PrimaryPart.Position
                    local Target_Distance = Player:DistanceFromCharacter(Target_Position)

                    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
                    local Ball_Direction = Zoomies.VectorVelocity.Unit

                    local Dot = Direction:Dot(Ball_Direction)

                    local Distance = Player:DistanceFromCharacter(Ball.Position)

                    if not Ball_Target then
                        return
                    end

                    if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then
                        return
                    end
                    
                    local Pulsed = Player.Character:GetAttribute('Pulsed')

                    if Pulsed then
                        return
                    end

                    if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then
                        return
                    end

                    local threshold = ParryThreshold

                    if Distance <= Spam_Accuracy and Parries > threshold then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                    end
                end)
            else
                if Connections_Manager['Animation Fix'] then
                    Connections_Manager['Animation Fix']:Disconnect()
                    Connections_Manager['Animation Fix'] = nil
                end
            end
        end
    })
end

SpamParry:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().SpamParryKeypress = value
    end
})

local ManualSpam = Blatant:AddSection({
	Name = "Manual Spam",
	Position = "left",
});

ManualSpam:AddToggle({
	Name = "Manual Spam Parry",
	Callback = function(value)
        if value then
            Connections_Manager['Manual Spam'] = RunService.PreSimulation:Connect(function()
                if getgenv().spamui then
                    return
                end

                if getgenv().ManualSpamKeypress then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                else
                    Auto_Parry.Parry(Selected_Parry_Type)
                end

            end)
        else
            if Connections_Manager['Manual Spam'] then
                Connections_Manager['Manual Spam']:Disconnect()
                Connections_Manager['Manual Spam'] = nil
            end
        end
    end
})

if isMobile then
    ManualSpam:AddToggle({
	Name = "UI",
	Callback = function(value)
        getgenv().spamui = value

        if value then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ManualSpamUI"
            gui.ResetOnSpawn = false
            gui.Parent = game.CoreGui

            local frame = Instance.new("Frame")
            frame.Name = "MainFrame"
            frame.Position = UDim2.new(0, 20, 0, 20)
            frame.Size = UDim2.new(0, 200, 0, 100)
            frame.BackgroundColor3 = Color3.fromRGB(10, 10, 50)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Draggable = true
            frame.Parent = gui

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, 12)
            uiCorner.Parent = frame

            local uiStroke = Instance.new("UIStroke")
            uiStroke.Thickness = 2
            uiStroke.Color = Color3.new(0, 0, 0)
            uiStroke.Parent = frame

            local button = Instance.new("TextButton")
            button.Name = "ClashModeButton"
            button.Text = "Clash Mode"
            button.Size = UDim2.new(0, 160, 0, 40)
            button.Position = UDim2.new(0.5, -80, 0.5, -20)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Font = Enum.Font.GothamSemibold
            button.TextColor3 = Color3.new(1, 1, 1)
            button.TextSize = 22
            button.Parent = frame

            local activated = false

            local function toggle()
                activated = not activated
                button.Text = activated and "Stop" or "Clash Mode"
                if activated then
                    Connections_Manager['Manual Spam UI'] = game:GetService("RunService").Heartbeat:Connect(function()
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end)
                else
                    if Connections_Manager['Manual Spam UI'] then
                        Connections_Manager['Manual Spam UI']:Disconnect()
                        Connections_Manager['Manual Spam UI'] = nil
                    end
                end
            end

            button.MouseButton1Click:Connect(toggle)
        else
            if game.CoreGui:FindFirstChild("ManualSpamUI") then
                game.CoreGui:FindFirstChild("ManualSpamUI"):Destroy()
            end

            if Connections_Manager['Manual Spam UI'] then
                Connections_Manager['Manual Spam UI']:Disconnect()
                Connections_Manager['Manual Spam UI'] = nil
            end
        end
    end
    })
end

ManualSpam:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().ManualSpamKeypress = value
    end
})

local Triggerbot = Blatant:AddSection({
	Name = "Triggerbot",
	Position = "right",
});

Triggerbot:AddToggle({
    Name = "Triggerbot",
    Callback = function(value)
        if value then
            Connections_Manager['Triggerbot'] = RunService.PreSimulation:Connect(function()
                local Balls = Auto_Parry.Get_Balls()
    
                for _, Ball in pairs(Balls) do
                    if not Ball then
                        return
                    end
                    
                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        TriggerbotParried = false
                    end)

                    if TriggerbotParried then
                        return
                    end

                    local Ball_Target = Ball:GetAttribute('target')
                    local Singularity_Cape = Player.Character.PrimaryPart:FindFirstChild('SingularityCape')
        
                    if Singularity_Cape then 
                        return
                    end 
                
                    if getgenv().TriggerbotInfinityDetection and Infinity then
                        return
                    end
    
                    if Ball_Target == tostring(Player) then
                        if getgenv().TriggerbotKeypress then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                        else
                            Auto_Parry.Parry(Selected_Parry_Type)
                        end
                        TriggerbotParried = true
                    end
                    local Triggerbot_Last_Parrys = tick()
                    repeat
                        RunService.PreSimulation:Wait()
                    until (tick() - Triggerbot_Last_Parrys) >= 1 or not TriggerbotParried
                    TriggerbotParried = false
                end

            end)
        else
            if Connections_Manager['Triggerbot'] then
                Connections_Manager['Triggerbot']:Disconnect()
                Connections_Manager['Triggerbot'] = nil
            end
        end
    end
})

Triggerbot:AddToggle({
    Name = "Infinity Detection",
    Callback = function(value)
        getgenv().TriggerbotInfinityDetection = value
    end
})

Triggerbot:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().TriggerbotKeypress = value
    end
})

local LobbyAP = Blatant:AddSection({
	Name = "Lobby Auto Parry",
	Position = "left",
});

LobbyAP:AddToggle({
    Name = "Lobby Auto Parry",
    Callback = function(value)
        if value then
            Connections_Manager['Lobby AP'] = RunService.Heartbeat:Connect(function()
                local Ball = Auto_Parry.Lobby_Balls()
                if not Ball then
                    return
                end

                local Zoomies = Ball:FindFirstChild('zoomies')
                if not Zoomies then
                    return
                end

                Ball:GetAttributeChangedSignal('target'):Once(function()
                    Training_Parried = false
                end)

                if Training_Parried then
                    return
                end

                local Ball_Target = Ball:GetAttribute('target')
                local Velocity = Zoomies.VectorVelocity
                local Distance = Player:DistanceFromCharacter(Ball.Position)
                local Speed = Velocity.Magnitude

                local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue() / 10
                local LobbyAPcappedSpeedDiff = math.min(math.max(Speed - 9.5, 0), 650)
                local LobbyAPspeed_divisor_base = 2.4 + LobbyAPcappedSpeedDiff * 0.002

                local LobbyAPeffectiveMultiplier = LobbyAP_Speed_Divisor_Multiplier
                if getgenv().LobbyAPRandomParryAccuracyEnabled then
                    LobbyAPeffectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                end

                local LobbyAPspeed_divisor = LobbyAPspeed_divisor_base * LobbyAPeffectiveMultiplier
                local LobbyAPParry_Accuracys = Ping + math.max(Speed / LobbyAPspeed_divisor, 9.5)

                if Ball_Target == tostring(Player) and Distance <= LobbyAPParry_Accuracys then
                    if getgenv().LobbyAPKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) 
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                    Training_Parried = true
                end
                local Last_Parrys = tick()
                repeat 
                    RunService.PreSimulation:Wait() 
                until (tick() - Last_Parrys) >= 1 or not Training_Parried
                Training_Parried = false
            end)
        else
            if Connections_Manager['Lobby AP'] then
                Connections_Manager['Lobby AP']:Disconnect()
                Connections_Manager['Lobby AP'] = nil
            end
        end
    end
})

module:AddToggle({
    	Name = "Phantom Detection",
	Min = 1,
	Max = 100,
	Default = 100,
	Callback = function(value)
        PhantomV2Detection = value
    end
})

LobbyAP:AddSlider({
	Name = "Parry Accuracy",
	Min = 1,
	Max = 100,
	Default = 100,
	Callback = function(value)
		LobbyAP_Speed_Divisor_Multiplier = 0.7 + (value - 1) * (0.35 / 99)
	end
})

LobbyAP:AddToggle({
    Name = "Random Parry Accuracy",
    Callback = function(value)
        getgenv().LobbyAPRandomParryAccuracyEnabled = value
    end
})

LobbyAP:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().LobbyAPKeypress = value
    end
})

local Strafe = player:AddSection({
	Name = "Strafe",
	Position = "left",
});

Strafe:AddToggle({
    Name = "Strafe",
    Callback = function(value)
        if value then
            Connections_Manager['Strafe'] = game:GetService("RunService").PreSimulation:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = StrafeSpeed
                end
            end)
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 36
            end
            
            if Connections_Manager['Strafe'] then
                Connections_Manager['Strafe']:Disconnect()
                Connections_Manager['Strafe'] = nil
            end
        end
    end
})

Strafe:AddSlider({
	Name = "Speed",
    Min = 36,
	Max = 200,
	Default = 36,
	Callback = function(value)
        StrafeSpeed = value
    end
})

local Spinbot = player:AddSection({
	Name = "Spinbot",
	Position = "right",
});

Spinbot:AddToggle({
    Name = "Spinbot",
    Callback = function(value)
        getgenv().Spinbot = value
        if value then
            getgenv().spin = true
            getgenv().spinSpeed = getgenv().spinSpeed or 1 
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local Client = Players.LocalPlayer

            
            local function spinCharacter()
                while getgenv().spin do
                    RunService.Heartbeat:Wait()
                    local char = Client.Character
                    local funcHRP = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if char and funcHRP then
                        funcHRP.CFrame *= CFrame.Angles(0, getgenv().spinSpeed, 0)
                    end
                end
            end

            
            if not getgenv().spinThread then
                getgenv().spinThread = coroutine.create(spinCharacter)
                coroutine.resume(getgenv().spinThread)
            end

        else
            getgenv().spin = false

            
            if getgenv().spinThread then
                getgenv().spinThread = nil
            end
        end
    end
})

Spinbot:AddSlider({
	Name = "Speed",
    Min = 1,
	Max = 100,
	Default = 1,
	Callback = function(value)
        getgenv().spinSpeed = math.rad(value)
    end
})

local FieldOfView = player:AddSection({
	Name = "Field of View",
	Position = "left",
});

FieldOfView:AddToggle({
    Name = "Field of View",
    Callback = function(value)
        getgenv().CameraEnabled = value
        local Camera = game:GetService("Workspace").CurrentCamera

        if value then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            Camera.FieldOfView = getgenv().CameraFOV
            
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = game:GetService("RunService").RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Camera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Camera.FieldOfView = 70
            
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})

FieldOfView:AddSlider({
	Name = "FOV",
    Min = 50,
	Max = 150,
	Default = 70,
	Callback = function(value)
        getgenv().CameraFOV = value
        if getgenv().CameraEnabled then
            game:GetService("Workspace").CurrentCamera.FieldOfView = value
        end
    end
})

local PlayerCosmetics = player:AddSection({
	Name = "Player Cosmetics",
	Position = "right",
});

_G.PlayerCosmeticsCleanup = {}

PlayerCosmetics:AddToggle({
    Name = "Player Cosmetics",
    Callback = function(value)
        local players = game:GetService("Players")
        local lp = players.LocalPlayer

        local function applyKorblox(character)
            local rightLeg = character:FindFirstChild("RightLeg") or character:FindFirstChild("Right Leg")
            if not rightLeg then
                warn("Right leg not found on character")
                return
            end
            
            for _, child in pairs(rightLeg:GetChildren()) do
                if child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
            local specialMesh = Instance.new("SpecialMesh")
            specialMesh.MeshId = "rbxassetid://101851696"
            specialMesh.TextureId = "rbxassetid://115727863"
            specialMesh.Scale = Vector3.new(1, 1, 1)
            specialMesh.Parent = rightLeg
        end

        local function saveRightLegProperties(char)
            if char then
                local rightLeg = char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
                if rightLeg then
                    local originalMesh = rightLeg:FindFirstChildOfClass("SpecialMesh")
                    if originalMesh then
                        _G.PlayerCosmeticsCleanup.originalMeshId = originalMesh.MeshId
                        _G.PlayerCosmeticsCleanup.originalTextureId = originalMesh.TextureId
                        _G.PlayerCosmeticsCleanup.originalScale = originalMesh.Scale
                    else
                        _G.PlayerCosmeticsCleanup.hadNoMesh = true
                    end
                    
                    _G.PlayerCosmeticsCleanup.rightLegChildren = {}
                    for _, child in pairs(rightLeg:GetChildren()) do
                        if child:IsA("SpecialMesh") then
                            table.insert(_G.PlayerCosmeticsCleanup.rightLegChildren, {
                                ClassName = child.ClassName,
                                Properties = {
                                    MeshId = child.MeshId,
                                    TextureId = child.TextureId,
                                    Scale = child.Scale
                                }
                            })
                        end
                    end
                end
            end
        end
        
        local function restoreRightLeg(char)
            if char then
                local rightLeg = char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
                if rightLeg and _G.PlayerCosmeticsCleanup.rightLegChildren then
                    for _, child in pairs(rightLeg:GetChildren()) do
                        if child:IsA("SpecialMesh") then
                            child:Destroy()
                        end
                    end
                    
                    if _G.PlayerCosmeticsCleanup.hadNoMesh then
                        return
                    end
                    
                    for _, childData in ipairs(_G.PlayerCosmeticsCleanup.rightLegChildren) do
                        if childData.ClassName == "SpecialMesh" then
                            local newMesh = Instance.new("SpecialMesh")
                            newMesh.MeshId = childData.Properties.MeshId
                            newMesh.TextureId = childData.Properties.TextureId
                            newMesh.Scale = childData.Properties.Scale
                            newMesh.Parent = rightLeg
                        end
                    end
                end
            end
        end

        if value then
            CosmeticsActive = true

            getgenv().Config = {
                Headless = true
            }
            
            if lp.Character then
                local head = lp.Character:FindFirstChild("Head")
                if head and getgenv().Config.Headless then
                    _G.PlayerCosmeticsCleanup.headTransparency = head.Transparency
                    
                    local decal = head:FindFirstChildOfClass("Decal")
                    if decal then
                        _G.PlayerCosmeticsCleanup.faceDecalId = decal.Texture
                        _G.PlayerCosmeticsCleanup.faceDecalName = decal.Name
                    end
                end
                
                saveRightLegProperties(lp.Character)
                applyKorblox(lp.Character)
            end
            
            _G.PlayerCosmeticsCleanup.characterAddedConn = lp.CharacterAdded:Connect(function(char)
                local head = char:FindFirstChild("Head")
                if head and getgenv().Config.Headless then
                    _G.PlayerCosmeticsCleanup.headTransparency = head.Transparency
                    
                    local decal = head:FindFirstChildOfClass("Decal")
                    if decal then
                        _G.PlayerCosmeticsCleanup.faceDecalId = decal.Texture
                        _G.PlayerCosmeticsCleanup.faceDecalName = decal.Name
                    end
                end
                
                saveRightLegProperties(char)
                applyKorblox(char)
            end)
            
            if getgenv().Config.Headless then
                headLoop = task.spawn(function()
                    while CosmeticsActive do
                        local char = lp.Character
                        if char then
                            local head = char:FindFirstChild("Head")
                            if head then
                                head.Transparency = 1
                                local decal = head:FindFirstChildOfClass("Decal")
                                if decal then
                                    decal:Destroy()
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end

        else
            CosmeticsActive = false

            if _G.PlayerCosmeticsCleanup.characterAddedConn then
                _G.PlayerCosmeticsCleanup.characterAddedConn:Disconnect()
                _G.PlayerCosmeticsCleanup.characterAddedConn = nil
            end

            if headLoop then
                task.cancel(headLoop)
                headLoop = nil
            end

            local char = lp.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head and _G.PlayerCosmeticsCleanup.headTransparency ~= nil then
                    head.Transparency = _G.PlayerCosmeticsCleanup.headTransparency
                    
                    if _G.PlayerCosmeticsCleanup.faceDecalId then
                        local newDecal = head:FindFirstChildOfClass("Decal") or Instance.new("Decal", head)
                        newDecal.Name = _G.PlayerCosmeticsCleanup.faceDecalName or "face"
                        newDecal.Texture = _G.PlayerCosmeticsCleanup.faceDecalId
                        newDecal.Face = Enum.NormalId.Front
                    end
                end
                
                restoreRightLeg(char)
            end

            _G.PlayerCosmeticsCleanup = {}
        end
    end
})

local Fly = player:AddSection({
	Name = "Fly",
	Position = "left",
});

Fly:AddToggle({
    Name = "Fly",
    Callback = function(value)
    if value then
            getgenv().FlyEnabled = true
            local char = Player.Character or Player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local humanoid = char:WaitForChild("Humanoid")
            
            getgenv().OriginalStateType = humanoid:GetState()
            
            getgenv().RagdollHandler = humanoid.StateChanged:Connect(function(oldState, newState)
                if getgenv().FlyEnabled then
                    if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
                        task.defer(function()
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end)
                    end
                end
            end)
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 90000
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.Parent = hrp
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = hrp
            
            humanoid.PlatformStand = true
            
            getgenv().ResetterConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().FlyEnabled then return end
                
                if bodyGyro and bodyGyro.Parent then
                    bodyGyro.P = 90000
                    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                end
                
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                end
                
                humanoid.PlatformStand = true
                
                if not bodyGyro.Parent or not bodyVelocity.Parent then
                    if bodyGyro then bodyGyro:Destroy() end
                    if bodyVelocity then bodyVelocity:Destroy() end
                    
                    bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.P = 90000
                    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bodyGyro.Parent = hrp
                    
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bodyVelocity.Parent = hrp
                end
            end)
            
            getgenv().FlyConnection = RunService.RenderStepped:Connect(function()
                if not getgenv().FlyEnabled then return end
                local camCF = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camCF.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camCF.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit
                end
                bodyVelocity.Velocity = moveDir * (getgenv().FlySpeed or 50)
                bodyGyro.CFrame = camCF
            end)
        else
            getgenv().FlyEnabled = false
            
            if getgenv().FlyConnection then
                getgenv().FlyConnection:Disconnect()
                getgenv().FlyConnection = nil
            end
            
            if getgenv().RagdollHandler then
                getgenv().RagdollHandler:Disconnect()
                getgenv().RagdollHandler = nil
            end
            
            if getgenv().ResetterConnection then
                getgenv().ResetterConnection:Disconnect()
                getgenv().ResetterConnection = nil
            end
            
            local char = Player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                
                if humanoid then
                    humanoid.PlatformStand = false
                    if getgenv().OriginalStateType then
                        humanoid:ChangeState(getgenv().OriginalStateType)
                    end
                end
                
                if hrp then
                    for _, v in ipairs(hrp:GetChildren()) do
                        if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end
})

Fly:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 100,
    Default = 50,
    Callback = function(value)
        getgenv().FlySpeed = value
    end
})

local HitSounds = player:AddSection({
	Name = "Hit Sounds",
	Position = "right",
});

HitSounds:AddToggle({
    Name = "Hit Sounds",
    Callback = function(value)
        hit_Sound_Enabled = value
    end
})

local Folder = Instance.new("Folder")
Folder.Name = "Useful Utility"
Folder.Parent = workspace

local hit_Sound = Instance.new('Sound', Folder)
hit_Sound.Volume = 6

local hitSoundOptions = { 
    "Medal", 
    "Fatality", 
    "Skeet",
    "Switches",
    "Rust Headshot", 
    "Neverlose Sound", 
    "Bubble", 
    "Laser", 
    "Steve", 
    "Call of Duty", 
    "Bat", 
    "TF2 Critical", 
    "Saber", 
    "Bameware"
}

local hitSoundIds = {
    Medal = "rbxassetid://6607336718",
    Fatality = "rbxassetid://6607113255",
    Skeet = "rbxassetid://6607204501",
    Switches = "rbxassetid://6607173363",
    ["Rust Headshot"] = "rbxassetid://138750331387064",
    ["Neverlose Sound"] = "rbxassetid://110168723447153",
    Bubble = "rbxassetid://6534947588",
    Laser = "rbxassetid://7837461331",
    Steve = "rbxassetid://4965083997",
    ["Call of Duty"] = "rbxassetid://5952120301",
    Bat = "rbxassetid://3333907347",
    ["TF2 Critical"] = "rbxassetid://296102734",
    Saber = "rbxassetid://8415678813",
    Bameware = "rbxassetid://3124331820"
}

HitSounds:AddSlider({
    Name = "Hit Sound Volume",
    Min = 0,
    Max = 10,
    Default = 6,
    Callback = function(value)
        hit_Sound.Volume = value
    end
})

HitSounds:AddDropdown({
    Name = "Hit Sound",
    Options = hitSoundOptions,
    Callback = function(selectedOption)
        if hitSoundIds[selectedOption] then
            hit_Sound.SoundId = hitSoundIds[selectedOption]
        end
    end
})

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if hit_Sound_Enabled then
        hit_Sound:Play()
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= Player.Character then
        if root.Parent.Parent ~= workspace.Alive then
            return
        end
    end

    Auto_Parry.Closest_Player()

    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return
    end

    local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)

    local Curve_Detected = Auto_Parry.Is_Curved()

    if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then -- wtf ?? maybe the big issue
        if Curve_Detected then
            Auto_Parry.Parry(Selected_Parry_Type)
        end
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if Player.Character.Parent ~= workspace.Alive then
        return
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

workspace.Balls.ChildAdded:Connect(function()
    Parried = false
end)

workspace.Balls.ChildRemoved:Connect(function(Value)
    Parries = 0
    Parried = false

    if Connections_Manager['Target Change'] then
        Connections_Manager['Target Change']:Disconnect()
        Connections_Manager['Target Change'] = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a, b)
    local Primary_Part = Player.Character.PrimaryPart
    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return
    end

    local Zoomies = Ball:FindFirstChild('zoomies')

    if not Zoomies then
        return
    end

    local Speed = Zoomies.VectorVelocity.Magnitude

    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Velocity = Zoomies.VectorVelocity

    local Ball_Direction = Velocity.Unit

    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)

    local Pings = Network.ServerStatsItem['Data Ping']:GetValue()


    local Speed_Threshold = math.min(Speed / 100, 40)
    local Reach_Time = Distance / Speed - (Pings / 1000)

    local Enough_Speed = Speed > 100
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold

    if Enough_Speed and Reach_Time > Pings / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
        Curving = tick()
    end
end)

game:GetService('ReplicatedStorage').Remotes.Phantom.OnClientEvent:Connect(function(a, b)
    if b.Name == tostring(Player) then
        Phantom = true
    else
        Phantom = false
    end
end)

local Balls = workspace:WaitForChild('Balls')

Balls.ChildRemoved:Connect(function()
    Phantom = false
end)
