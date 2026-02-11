local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TagService = require(ReplicatedStorage.Services.TagService)
local RunService = game:GetService("RunService")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local Prompt = ReplicatedStorage.Props.Prompts.CrawlPrompt

local Player = Players.LocalPlayer

local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local Signal = require(ReplicatedStorage.Classes.Signal)

local Cooldown = 5

local DisableSignal = Signal.new()

local Hole = {}
Hole.__index = Hole

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Triggered = self.Prompt.Triggered:Connect(function()
		self:Crawl()
	end)
	self.Connections.Disable = DisableSignal:Connect(function()
		self.Prompt.Enabled = false
		task.wait(Cooldown)
		self.Prompt.Enabled = true
	end)
end

function Hole.new(hole: Model)
	local self = setmetatable({}, Hole)

	
	self.Hole = hole
	self.Prompt = Prompt:Clone()
	self.Prompt.Parent = self.Hole.PrimaryPart
	
	self.VFXPart = self.Hole.VFXPart
	
	setUpConnections(self)
	
	return self
end

function Hole:Crawl()
	local target = TagService:GetTaggedOfPredicate("Object", function(v)
		return v:GetAttribute("Class") == "Hole" and v:GetAttribute("ID") == self.Hole:GetAttribute("ID") and v ~= self.Hole
	end)[1]
	if not target then warn("no hole found") end
	--for now just tp player
	local character = Player.Character
	if not character then warn("no character found") end
	local humanoid: Humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then warn("no humanoid found") end
	DisableSignal:Fire()
	Controls:Disable()
	humanoid:MoveTo(self.Hole:GetPivot().Position)
	
	--[[
	Play vfx
	]]
	
	local track = humanoid.Animator:LoadAnimation(self.Hole.Animations.Crawl)
	local completed = nil
	task.spawn(function()
		humanoid.MoveToFinished:Wait()
		completed = "MoveToFinished"
	end)
	task.spawn(function()
		task.wait(1.5)
		completed = "Timeout"
	end)
	repeat RunService.RenderStepped:Wait() until completed ~= nil
	character.PrimaryPart.Anchored = true
	track:Play()
	task.delay(0.3, function()
		AudioService:Add3D("HoleIn", character.PrimaryPart, false, "HoleIn")
	end)
	track:GetMarkerReachedSignal("Change"):Wait()
	character:PivotTo(CFrame.new(target:GetPivot().Position + Vector3.new(0, 3.5, 0)))
	task.spawn(function()
		task.wait(0.2)
		for _, instance:Instance in target.VFXPart:GetDescendants() do
			if instance:IsA("ParticleEmitter") then
				instance:Emit(instance:GetAttribute("EmitCount"))
			end
		end
	end)
	track:GetMarkerReachedSignal("Unanchor"):Wait()
	AudioService:Add3D("HoleIn", character.PrimaryPart, false, "HoleOut")
	character.PrimaryPart.Anchored = false
	Controls:Enable()
	track.Ended:Wait()
	
end

return Hole
