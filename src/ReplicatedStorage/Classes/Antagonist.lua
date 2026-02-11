local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ChaseMusicService = require(ReplicatedStorage.Services.ChaseMusicService)
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

local Antagonist = {}
Antagonist.__index = Antagonist

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Touched = self.Antagonist:WaitForChild("Hitbox").Touched:Connect(function(hit)
		if hit.Parent ~= Player.Character then return end
		if hit.Parent:HasTag("Ignore") then return end
		if self.Cooling then return end
		self.Cooling = true
		ReplicatedStorage.Communication.Antagonist.Kill:FireServer(self.Antagonist)
		task.wait(3)
		self.Cooling = false
	end)
	self.Connections.Destroying = self.Antagonist.Destroying:Connect(function()
		print("DESTROYED")
		ChaseMusicService:Remove(self.Antagonist)
		RunService:UnbindFromRenderStep(`{self.Id}`)
	end)
end

function Antagonist.new(antagonist: Model)
	local self = setmetatable({}, Antagonist)
	
	self.Antagonist = antagonist
	self.Cooling = false
	
	setUpConnections(self)
	self:Start()
	
	return self
end

function Antagonist:Start()
	self.Id = HttpService:GenerateGUID()
	RunService:BindToRenderStep(`{self.Id}`, 1, function()
		if Player.Character == nil or Player.Character.PrimaryPart == nil then return end
		if self.Antagonist.PrimaryPart == nil then return end
		local distance = (self.Antagonist.PrimaryPart.Position - Player.Character.PrimaryPart.Position).Magnitude
		ChaseMusicService:Set(self.Antagonist, distance, Player.Character:HasTag("Downed"))
	end)
end

return Antagonist