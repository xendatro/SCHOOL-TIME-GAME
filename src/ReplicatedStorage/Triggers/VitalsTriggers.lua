local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VitalsService = require(ReplicatedStorage.Services.VitalsService)

local Communication = ReplicatedStorage.Communication

local Triggers = {}

Triggers.Create = Communication.Vitals:FindFirstChild("Create").OnClientEvent:Connect(function(...)
	VitalsService:Create(...)
end)

Triggers.Destroy = Communication.Vitals:FindFirstChild("Destroy").OnClientEvent:Connect(function(...)
	VitalsService:Destroy(...)
end)

Triggers.SetHunger = Communication.Hunger:FindFirstChild("Set").OnClientEvent:Connect(function(...)
	VitalsService:SetHunger(...)
end)

return Triggers