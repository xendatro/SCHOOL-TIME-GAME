local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local button = script.Parent

button.MouseButton1Click:Connect(function()
	TeleportService:Teleport(78163591327317, Players.LocalPlayer)
end)