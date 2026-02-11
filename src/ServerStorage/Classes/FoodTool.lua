local ServerStorage = game:GetService("ServerStorage")
local VitalsService = require(ServerStorage.Services.VitalsService)
local Players = game:GetService("Players")
local BackpackService = require(ServerStorage.Services.BackpackService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EatAnimation = ReplicatedStorage.Props.Animations.Eat

local FoodTool = {}
FoodTool.__index = FoodTool

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Equipped = self.Tool.Equipped:Connect(function()
		self:Equipped()
	end)
	self.Connections.Activated = self.Tool.Activated:Connect(function()
		self:Activated()
	end)
	self.Connections.Unequipped = self.Tool.Unequipped:Connect(function()
		self:Unequipped()
	end)
end

function FoodTool.new(tool: Tool)
	local self = setmetatable({}, FoodTool)
	self.Tool = tool
	
	setUpConnections(self)
	
	return self
end

function FoodTool:Activated()
	local player = Players:GetPlayerFromCharacter(self.Tool.Parent)
	if not player then return end
	local vitals = VitalsService:GetVitals(player)
	if not vitals then return end
	if self.Track then
		self.Track:Play()
		self.Track:AdjustSpeed(2)
	end
	vitals:AddHunger(self.Tool:GetAttribute("Hunger"))
	BackpackService:Remove(player, "Food", 1)
end

function FoodTool:Equipped()
	local humanoid: Humanoid = self.Tool.Parent:FindFirstChild("Humanoid")
	if not humanoid then return end
	local track: AnimationTrack = humanoid.Animator:LoadAnimation(EatAnimation)
	self.Track = track
end

function FoodTool:Unequipped()
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	table.clear(self)
end

return FoodTool