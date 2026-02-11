local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)

local Triggers = {}

Triggers.Remove = ReplicatedStorage.Communication.Backpack.Delete.OnServerEvent:Connect(function(...)
	BackpackService:Remove(...)
end)

return Triggers
