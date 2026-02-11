local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShakeService = require(ReplicatedStorage.Services.ShakeService)

local Triggers = {}


Triggers.Create = ReplicatedStorage.Communication.Shake.Create.OnClientEvent:Connect(function(...)
	ShakeService:Create(...)
end)

Triggers.Delete = ReplicatedStorage.Communication.Shake.Delete.OnClientEvent:Connect(function(...)
	ShakeService:Delete(...)
end)

return Triggers