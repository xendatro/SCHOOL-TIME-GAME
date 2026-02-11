local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Classes.Signal)

local Visual = {}
Visual.__index = Visual

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Update = ReplicatedStorage.Communication.Visual.Update.OnServerEvent:Connect(function(player, instance, value)
		if self.Model ~= instance then return end
		self.Lookers[player] = value
		self:Check()
	end)
	self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
		self.Lookers[player] = false
	end)
	self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
		self.Lookers[player] = nil
	end)
end


function Visual.new(model: Model)
	local self = setmetatable({}, Visual)
	
	self.Model = model
	self.Lookers = {}
	self.Looking = false
	
	self.Changed = Signal.new()
	
	for _, player in Players:GetPlayers() do
		self.Lookers[player] = false --assume false for all yeah it's fine
	end
 	setUpConnections(self)
	
	return self
end

function Visual:Check()
	local isLooking = false
	for player, looking in self.Lookers do
		if looking then
			isLooking = true
			break
		end
	end
	if isLooking ~= self.Looking then
		self.Looking = isLooking
		self.Changed:Fire(self.Looking)
	end
end


return Visual