local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)

local Triggers = {}

Triggers.Toggle = ReplicatedStorage.Communication.Objective.Toggle.OnClientEvent:Connect(function(...)
	ObjectiveService:Toggle(...)
end)

Triggers.Update = ReplicatedStorage.Communication.Objective.Update.OnClientEvent:Connect(function(...)
	ObjectiveService:Update(...)
end)

return Triggers