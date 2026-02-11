local ServerStorage = game:GetService("ServerStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AudioService = require(ReplicatedStorage.Services.AudioService)


local Healer = {}
Healer.__index = Healer

local function setUpConnections(self)
	self.Connections = {}
	
	self.Connections.Activated = self.Healer.Activated:Connect(function()
		local character = self.Healer.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end
		
		AudioService:Add3D("Heal", character.PrimaryPart, false, self.HealSound)
		
		BackpackService:Remove(player, self.Healer.Name, 1)
		character.Humanoid.Health += self.Amount
	end)
end

function Healer.new(healer: Tool, amount: number, healSound: string)
	local self = setmetatable({}, Healer)
	
	self.Healer = healer
	self.Amount = amount
	self.HealSound = healSound
	
	setUpConnections(self)
	
	return self
end

return Healer