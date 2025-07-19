local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

-- Создание основного окна GUI
local Window = Fluent:CreateWindow({
    Title = "GendioHub 〢 Stellar",
    SubTitle = "discord.gg/hBTDRZrf",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 400),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Создание вкладок
local Tabs = {
    Updates = Window:AddTab({ Title = "Home", Icon = "home" }),
    Main = Window:AddTab({ Title = "Main", Icon = "rocket" }),
    Server = Window:AddTab({ Title = "Server", Icon = "server" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Элементы интерфейса на вкладке Main
Tabs.Main:AddParagraph({ Title = "Lock Time: Not Set" })

Tabs.Main:AddButton({
    Title = "Steal",
    Description = "Teleports you to your own base"
})

Tabs.Main:AddSlider("Slider", {
    Title = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 6,
    Rounding = 1
})

Tabs.Main:AddParagraph({
    Title = "Use Speed Coil/Invisibility Cloak For Higher Speed"
})

Tabs.Main:AddButton({
    Title = "Invisible",
    Description = "Use Invisibility Cloak"
})

Tabs.Main:AddDropdown("MultiDropdown", {
    Title = "Esp",
    Values = {"Lock", "Players", "Legendary", "Mythic", "Brainrot God", "Secret"},
    Multi = true,
    Default = {}
})

Tabs.Main:AddKeybind("Keybind", {
    Title = "Steal Keybind",
    Mode = "Toggle",
    Default = "G"
})

Tabs.Main:AddKeybind("Keybind", {
    Title = "Shop",
    Mode = "Toggle",
    Default = "F",
    Description = "Opens/Closes shop"
})

-- Элементы интерфейса на вкладке Server
Tabs.Server:AddDropdown("MultiDropdown", {
    Title = "Pet Finder",
    Values = {"Pet1", "Pet2", "Pet3"},
    Multi = true,
    Default = {}
})

Tabs.Server:AddParagraph({
    Title = "No pets selected"
})

Tabs.Server:AddSection("Other")

Tabs.Server:AddButton({
    Title = "Server Hop",
    Description = "Joins a Different Server"
})

Tabs.Server:AddButton({
    Title = "Rejoin",
    Description = "Rejoins The Same Server"
})

-- Элементы интерфейса на вкладке Updates
Tabs.Updates:AddParagraph({ Title = "Time: 00:00:00" })

Tabs.Updates:AddButton({
    Title = "Discord Server",
    Description = "Copies Discord Invite Link"
})

Tabs.Updates:AddButton({
    Title = "Run Infinite Yield"
})

-- Настройка SaveManager
SaveManager:SetLibrary(Fluent)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
