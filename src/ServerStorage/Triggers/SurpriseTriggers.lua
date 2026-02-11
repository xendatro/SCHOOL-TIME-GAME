local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local SurpriseService = require(ServerStorage.Services.SurpriseService)

local Triggers = {}

Triggers.InstanceAdded = CollectionService:GetInstanceAddedSignal("SurpriseBlock"):Connect(function(instance)
	SurpriseService:Create(instance)
end)


for _, instance in CollectionService:GetTagged("SurpriseBlock") do
	SurpriseService:Create(instance)
end

return Triggers