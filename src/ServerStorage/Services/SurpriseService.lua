local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Signal = require(ReplicatedStorage.Classes.Signal)

local Signal = require(ReplicatedStorage.Classes.Signal)
local Visual = require(ServerStorage.Classes.Visual)

local Cooldown = 20
local Angle = 90


local SurpriseService = {}

local SurpriseBlock = {}
SurpriseBlock.__index = SurpriseBlock

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Touched = self.Block.Touched:Connect(function(hit)
		if self.Cooling then return end
		local character = hit.Parent
		if character:HasTag("Downed") then return end
		local player = Players:GetPlayerFromCharacter(character) 
		if not player then return end
		local moveDirection = character.PrimaryPart.AssemblyLinearVelocity.Unit
		local lookDirection = self.Block.CFrame.LookVector
		local angleDiff = math.abs(math.deg(math.acos(moveDirection:Dot(lookDirection)/(moveDirection.Magnitude * lookDirection.Magnitude))))
		if angleDiff > Angle then return end
		if self.LookAt ~= nil and self.LookAt.Looking == true then return end
		if #SurpriseService.Antagonists == 0 then return end
		self.Block:SetAttribute("Cooling", true)
		self.Cooling = true
		self.Triggered:Fire(player, self)
		task.wait(20)
		self.Cooling = false
		self.Block:SetAttribute("Cooling", false)
	end)
end

function SurpriseBlock.new(block: Part)
	local self = setmetatable({}, SurpriseBlock)

	self.Block = block
	self.Cooling = false
	self.Triggered = Signal.new()

	self.LookAt = if block.Parent:FindFirstChild("LookAt") then Visual.new(block.Parent.LookAt) else nil

	setUpConnections(self)

	return self
end


SurpriseService.SurpriseBlocks = {}
SurpriseService.SurpriseConnections = {}

SurpriseService.Antagonists = {}

function SurpriseService:Create(instance)
	SurpriseService.SurpriseBlocks[instance] = SurpriseBlock.new(instance)
	SurpriseService.SurpriseConnections[instance] = SurpriseService.SurpriseBlocks[instance].Triggered:Connect(function(player, block)
		if #SurpriseService.Antagonists == 0 then return end
		local randomAntagonist = SurpriseService.Antagonists[math.random(1, #SurpriseService.Antagonists)]
		randomAntagonist:SetState("Surprise", {
			SurpriseBlock = block.Block,
			Player = player,
		})
		SurpriseService:Remove(randomAntagonist)
	end)
end

function SurpriseService:Add(antagonist)
	table.insert(SurpriseService.Antagonists, antagonist)
	print(`added {antagonist.Antagonist.Name}`)
end

function SurpriseService:Remove(antagonist)
	local index = table.find(SurpriseService.Antagonists, antagonist)
	if index then
		table.remove(SurpriseService.Antagonists, index)
	end
end


return SurpriseService