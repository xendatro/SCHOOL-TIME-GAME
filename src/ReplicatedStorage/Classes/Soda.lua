local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AudioService = require(ReplicatedStorage.Services.AudioService)
local Players = game:GetService("Players")

local Camera = workspace.CurrentCamera

local Delete = ReplicatedStorage.Communication.Backpack.Delete

local Soda = {}
Soda.__index = Soda

local Engine = nil

local SprintSpeed = 30
local t = 12

local fovTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)

local fovStartTween = TweenService:Create(
	Camera,
	fovTweenInfo,
	{
		FieldOfView = 120
	}
)

local fovStopTween = TweenService:Create(
	Camera,
	fovTweenInfo,
	{
		FieldOfView = 70
	}
)

local function use(character: Model)
	if Engine then
		coroutine.close(Engine)
	end
	Engine = coroutine.create(function()
		fovStartTween:Play()
		AudioService:Add("Soda", "SFX", false, "Soda")
		local humanoid: Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = SprintSpeed
		task.wait(t)
		fovStopTween:Play()
		humanoid.WalkSpeed = Players:GetPlayerFromCharacter(character):GetAttribute("WalkSpeed")
	end)
	coroutine.resume(Engine)
end

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Soda.Activated:Connect(function()
		self:Activated()
	end)
end

function Soda.new(soda: Tool)
	local self = setmetatable({}, Soda)
	self.Soda = soda
	
	setUpConnections(self)
	
	return self
end

function Soda:Activated()
	use(self.Soda.Parent)
	Delete:FireServer("Soda", 1)
end

return Soda