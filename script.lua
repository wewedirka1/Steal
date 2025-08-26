-- Immediate kick script by GendioHub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait briefly to ensure LocalPlayer is fully loaded
wait(0.5)

-- Attempt to kick the player
local success, errorMessage = pcall(function()
    LocalPlayer:Kick("Join our new Discord server: https://discord.gg/t45UCWPGcm By GendioHub")
end)

-- Debug output if the kick fails
if not success then
    warn("Failed to kick player: " .. tostring(errorMessage))
end

