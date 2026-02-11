local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local HoleService = require(ServerStorage.Services.HoleService)

local Triggers = {}

ReplicatedStorage.Communication.Hole.Create.OnServerInvoke = function(_, position)
	HoleService:CreateHolePair(position)
end

return Triggers