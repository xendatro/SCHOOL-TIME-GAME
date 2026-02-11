local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local TweenService = require(ReplicatedStorage.Services.TweenService)
local Debris = game:GetService("Debris")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local Create = ReplicatedStorage.Communication.Hole.Create
local Delete = ReplicatedStorage.Communication.Backpack.Delete

local DummyHole = ReplicatedStorage.Props.Other.DummyHole

local Shovel = {}
Shovel.__index = Shovel

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Shovel.Activated:Connect(function()
		self:Activated()
	end)
	self.Connections.Equipped = self.Shovel.Equipped:Connect(function()
		self.Character = self.Shovel.Parent
		self.Humanoid = self.Character.Humanoid
		self.Track = self.Humanoid.Animator:LoadAnimation(self.Shovel.Animations.Equip)
		self.Track.Priority = Enum.AnimationPriority.Action
		self.Track:Play(0.25)
	end)
	self.Connections.Unequipped = self.Shovel.Unequipped:Connect(function()
		if self.Track then
			self.Track:Stop()
		end
	end)
end

function Shovel.new(shovel: Tool)
	local self = setmetatable({}, Shovel)
	
	
	self.Shovel = shovel
	self.Playing = false
	
	setUpConnections(self)
	
	return self
end

function Shovel:Activated()
	if self.Playing then return end
	local exclude = CollectionService:GetTagged("HoleArea")
	table.insert(exclude, self.Character)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = exclude
	local result = workspace:Raycast(self.Character:GetPivot().Position, Vector3.new(0, -100, 0), params)
	if not result then return end
	if result.Instance:HasTag("ShovelAvoid") then return end
	local position = result.Position + Vector3.new(0, 0.5, 0)
	self.Playing = true
	AudioService:Add3D("Shovel", self.Character.PrimaryPart, false, "Shovel")
	local dummyHole = DummyHole:Clone()
	local x, y, z = dummyHole:GetPivot():ToOrientation()
	dummyHole:PivotTo(CFrame.new(position) * CFrame.fromOrientation(x, y, z))
	dummyHole:ScaleTo(0.1)
	dummyHole.Parent = workspace
	self.Character.Humanoid.WalkSpeed = 0
	local track = self.Character.Humanoid.Animator:LoadAnimation(self.Shovel.Animations.Dig)
	track:Play()
	track.Priority = Enum.AnimationPriority.Action2
	TweenService:CreateMethodTween(dummyHole, TweenInfo.new(2, Enum.EasingStyle.Linear), "ScaleTo", 0.1, 0.792):Play()
	track.Ended:Wait()
	self.Character.Humanoid.WalkSpeed = Players:GetPlayerFromCharacter(self.Character):GetAttribute("WalkSpeed")
	if self.Shovel:GetAttribute("quantity") <= 1 and self.Track then
		self.Track:Stop()
	end
	Delete:FireServer("Shovel", 1)
	Create:InvokeServer(position)
	dummyHole:Destroy()
	self.Playing = false
end



return Shovel