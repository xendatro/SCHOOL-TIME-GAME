local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AudioService = require(ReplicatedStorage.Services.AudioService)
local ShakeService = require(ReplicatedStorage.Services.ShakeService)
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local ChaseMusicService = {}

ChaseMusicService.Instances = {}

local minDistance = 60
local musicMagnitude = 0.6
local shakeMagnitude = 1

function ChaseMusicService:Start()
	self.Music = AudioService:Add("ChaseMusic", "Ambience", true, "ChaseMusic")
	self.Shake = ShakeService:CreateDynamicRumble(0)
end

function ChaseMusicService:Evaluate()
	local character = Player.Character
	local t = {}
	for instance, distance in ChaseMusicService.Instances do
		if not instance:IsDescendantOf(workspace) then
			continue
		end
		table.insert(t, distance)
	end
	if #t == 0 or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
		self.Music.Volume = 0
		self.Shake:AdjustValue(0)
		return
	end
	local shortestDistance = math.min(table.unpack(t))
	if shortestDistance > minDistance or character:HasTag("Downed") then 
		self.Music.Volume = 0
		self.Shake:AdjustValue(0)
		return
	end
	self.Music.Volume = musicMagnitude - (shortestDistance/minDistance) * musicMagnitude
	self.Shake:AdjustValue(shakeMagnitude - (shortestDistance/minDistance) * shakeMagnitude)
end

function ChaseMusicService:Set(instance, distance)
	self.Instances[instance] = distance
	self:Evaluate()
end


function ChaseMusicService:Remove(instance)
	if instance == nil then return end
	print("REMOVEEEE")
	self.Instances[instance] = nil
	self:Evaluate()
end

return ChaseMusicService