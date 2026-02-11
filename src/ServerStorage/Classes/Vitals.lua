local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hunger = require(ServerStorage.Classes.Hunger)

local Create = ReplicatedStorage.Communication.Vitals:FindFirstChild("Create")
local Destroy = ReplicatedStorage.Communication.Vitals:FindFirstChild("Destroy")

local Vitals = {}
Vitals.__index = Vitals

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Died = self.Character:WaitForChild("Humanoid").Died:Once(function()
		self.DestroyFunction()
	end)
end

function Vitals.new(player: Player, destroyFunction)
	local self = setmetatable({}, Vitals)
	
	self.Player = player
	self.Character = self.Player.Character or self.Player.CharacterAdded:Wait()
	self.Hunger = Hunger.new(player)
	self.DestroyFunction = destroyFunction
	
	Create:FireClient(player)
	
	setUpConnections(self)
	
	return self
end

function Vitals:AddHunger(n: number)
	self.Hunger:Add(n)
end

function Vitals:SubtractHunger(n: number)
	self.Hunger:Subtract(n)
end

function Vitals:ResumeHunger()
	self.Hunger:Resume()
end

function Vitals:PauseHunger()
	self.Hunger:Pause()
end

function Vitals:Destroy()
	Destroy:FireClient(self.Player)
	self.Hunger:Destroy()
	table.clear(self)
end

return Vitals 