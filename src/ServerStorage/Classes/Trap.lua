local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local Players = game:GetService("Players")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local Other = ReplicatedStorage.Props.Other

local Trap = {}
Trap.__index = Trap

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Trap.Activated:Connect(function()
		AudioService:Add3D("PlaceTrap", self.Trap.Handle, false, "PlaceTrap")
		self:Activated()
	end)
	self.Connections.Equipped = self.Trap.Equipped:Connect(function()
		self.Character = self.Trap.Parent
	end)
end

function Trap.new(trap: Tool)
	local self = setmetatable({}, Trap)
	self.Trap = trap
	
	setUpConnections(self)
	
	return Trap
end

function Trap:Activated()
	local cframe = self.Character:GetPivot()
	local clone = Other.Trap:Clone()
	clone:PivotTo(cframe)
	clone.Parent = workspace
	BackpackService:Remove(Players:GetPlayerFromCharacter(self.Character), "Trap", 1)
end

	
return Trap
