local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local AudioService = require(ReplicatedStorage.Services.AudioService)



local EvilLocker = {}
EvilLocker.__index = EvilLocker

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Touched = self.LockerTouch.Touched:Connect(function(hit)
		if self.Active == false then return end
		if self.Attacking then return end
		local character = hit.Parent
		if character:HasTag("Ignore") then return end
		local player = Players:GetPlayerFromCharacter(character)
		if player == nil then return end
		
		self.Attacking = true
		
		character.Humanoid.WalkSpeed = 0
		self.IdleTrack:Stop()
		self.AttackTrack:Play()
		self.AttackTrack.Looped = false
		task.delay(0.3, function()
			ReplicatedStorage.Communication.Shake.Create:FireClient(player, {
				ID = "Locker",
				ShakeType = "Once",
				Preset = "Scare"
			})
		end)
		task.delay(0.5, function()
			character.Humanoid.Health -= 40
			task.wait(0.5)
			character.Humanoid.WalkSpeed = player:GetAttribute("WalkSpeed")
		end)
		self.AttackTrack.Ended:Wait()
		self.IdleTrack:Play()
		
		task.wait(self.Cooldown)
		
		self.Attacking = false
	end)
end

function EvilLocker.new(locker: Model)
	local self = setmetatable({}, EvilLocker)

	self.EvilLocker = locker
	self.Locker = self.EvilLocker.EvilLocker
	self.Tentacles = self.EvilLocker.LockerTentacles
	
	self.LockerTouch = self.EvilLocker.LockerTouch
	
	self.Active = false
	self.RestingTime = 25
	self.ActiveTime = 15
	
	self.Cooldown = 4
	self.Attacking = false
	
	self.OpenTrack = self.Locker.AnimationController.Animator:LoadAnimation(self.Locker.AnimationController.Animator.Open)
	self.IdleTrack = self.Tentacles.AnimationController.Animator:LoadAnimation(self.Tentacles.AnimationController.Animator.Idle)
	self.AttackTrack = self.Tentacles.AnimationController.Animator:LoadAnimation(self.Tentacles.AnimationController.Animator.Attack)
	

	self.OpenTrack:Play()
	self.OpenTrack:AdjustSpeed(0)
	
	self.IdleTrack:Play()
	
	setUpConnections(self)
	
	self:Start()

	return self
end

function EvilLocker:Start()
	self.Engine = coroutine.create(function()
		task.wait(math.random(0, 20))
		while true do
			self:Rest()
			task.wait(self.RestingTime)
			self:Awake()
			task.wait(self.ActiveTime)
		end
	end)
	print(coroutine.resume(self.Engine))
end

function EvilLocker:Rest()
	self.Active = false
	self.Tentacles.Locker.Transparency = 1
	self.OpenTrack:AdjustSpeed(-1)
	local newID = HttpService:GenerateGUID()
	if self.TentacleId then
		AudioService:Remove(`{self.TentacleId}`)
	end
	AudioService:Add3D(`{newID}`, self.Locker:GetChildren()[1], false, "Locker", 1.2)
	task.delay(1.2, function()
		AudioService:Remove(`{newID}`)
	end)
	self.OpenTrack.Ended:Wait()
	self.OpenTrack:AdjustSpeed(0)
end

function EvilLocker:Awake()
	self.OpenTrack:Play()
	self.Tentacles.Locker.Transparency = 0
	self.OpenTrack:AdjustSpeed(1)
	local newID = HttpService:GenerateGUID()
	
	self.TentacleId = HttpService:GenerateGUID()
	AudioService:Add3D(`{self.TentacleId}`, self.Locker:GetChildren()[1], true, "Tentacles")

	AudioService:Add3D(`{newID}`, self.Locker:GetChildren()[1], false, "Locker")
	task.delay(1.2, function()
		AudioService:Remove(`{newID}`)
	end)
	self.OpenTrack:GetMarkerReachedSignal("Opened"):Wait()
	self.OpenTrack:AdjustSpeed(0)
	self.Active = true
end

return EvilLocker