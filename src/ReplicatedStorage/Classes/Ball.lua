local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)
local RunService = game:GetService("RunService")

local AudioService = require(ReplicatedStorage.Services.AudioService)

local Delete = ReplicatedStorage.Communication.Backpack.Delete

local Other = ReplicatedStorage.Props.Other

local Ball = {}
Ball.__index = Ball

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Ball.Activated:Connect(function()
		self:Activate()
	end)
	self.Connections.Equipped = self.Ball.Equipped:Connect(function(mouse: Mouse)
		self.ThrowTrack = self.Ball.Parent.Humanoid.Animator:LoadAnimation(self.Ball.Animations.Throw)
		self.Mouse = mouse
	end)
end

function Ball.new(ball: Tool)
	local self = setmetatable({}, Ball)
	
	self.Ball = ball
	
	setUpConnections(self)
	
	return self
end

function Ball:Activate()
	if self.Playing then return end
	local final = self.Mouse.Hit.Position
	local start = self.Ball:GetPivot().Position
	local character = self.Ball.Parent
	local direction = (final - start).Unit * 60
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = TagService:GetTaggedOfAncestor(workspace, "Antagonist")
	params.FilterType = Enum.RaycastFilterType.Include
	local result = workspace:Raycast(start, direction, params)
	if not result then return end
	Delete:FireServer("Ball", 1)
	local antagonist = result.Instance
	repeat antagonist = antagonist.Parent until antagonist:HasTag("Antagonist")
	self.Playing = true
	self.ThrowTrack:Play()
	local face = coroutine.create(function()
		while true do
			character:PivotTo(CFrame.new(character:GetPivot().Position, antagonist:GetPivot().Position))
			RunService.Heartbeat:Wait()
		end
	end)
	coroutine.resume(face)
	self.ThrowTrack:GetMarkerReachedSignal("Throw"):Wait()
	if self.Ball:FindFirstChild("Ball") then
		AudioService:Add3D("ThrowBall", self.Ball.Ball, false, "Ball")
	end
	self:Throw(self.Ball:GetPivot(), antagonist)
	if self.Ball:GetAttribute("quantity") == 0 then
		self.Ball.Ball:Destroy()	
	end
	self.ThrowTrack.Ended:Wait()
	coroutine.close(face)
	self.Playing = false
end

function Ball:Throw(ballCFrame: CFrame, antagonist)
	local engine = coroutine.create(function()
		local clone = Other.Ball:Clone()
		local head = antagonist:FindFirstChild("Head")
		local start = ballCFrame
		local magnitude = (head.CFrame.Position - ballCFrame.Position).Magnitude
		local t = magnitude/90
		local increments = 50
		clone.Parent = workspace
		for i = 1, increments do
			clone.CFrame = start:Lerp(head.CFrame, i/increments)
			task.wait(t/increments)
		end
		clone:Destroy()
		ReplicatedStorage.Communication.Ball.Hit:FireServer(antagonist)
	end)
	coroutine.resume(engine)
end

return Ball