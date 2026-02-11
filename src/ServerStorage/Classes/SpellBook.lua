local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local BackpackService = require(ServerStorage.Services.BackpackService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local BookEffects = ReplicatedStorage.Props.Other.BookEffects
local VFXDummy = ReplicatedStorage.Props.Other.VFXDummy


local SpellBook = {}
SpellBook.__index = SpellBook

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Equipped = self.SpellBook.Equipped:Connect(function()
		self.Character = self.SpellBook.Parent
	end)
	self.Connections.Activated = self.SpellBook.Activated:Connect(function()
		self:Activated()
	end)
end

function SpellBook.new(spellBook: Tool)
	local self = setmetatable({}, SpellBook)
	
	self.SpellBook = spellBook
	
	self.Playing = false
	
	setUpConnections(self)
	
	return self
end

function SpellBook:Activated()
	if self.Playing then return end
	self.Playing = true
	self.Character:AddTag("Ignore")
	local track = self.Character.Humanoid.Animator:LoadAnimation(self.SpellBook.Animations.Book)
	track:Play()
	AudioService:Add3D("SpellBook", self.SpellBook.Handle, false, "SpellBook")
	local effects = BookEffects:Clone()
	local humanEffects = VFXDummy:Clone()
	local engine = coroutine.create(function()
		task.wait(1)
		effects.Parent = workspace
		for _, effect in effects.Attachment:GetChildren() do
			effect.Enabled = true
		end
		
		while RunService.Heartbeat:Wait() do
			effects:PivotTo(self.SpellBook["Meshes/Unrigged"].CFrame)
		end
	end)
	coroutine.resume(engine)
	local engine2 = coroutine.create(function()
		task.wait(1.8)
		humanEffects.Parent = workspace
		humanEffects:PivotTo(self.Character:GetPivot())
		local motor = Instance.new("Motor6D")
		motor.Part0 = self.Character.PrimaryPart
		motor.Part1 = humanEffects.PrimaryPart
		motor.Parent = humanEffects.PrimaryPart
	end)
	coroutine.resume(engine2)
	local speed = self.Character.Humanoid.WalkSpeed -- will have to change this later cuz of the soda and other ways to change walkspseed
	self.Character.Humanoid.WalkSpeed = 0
	track:GetMarkerReachedSignal("BookEnd"):Wait()
	coroutine.close(engine)
	for _, effect in effects.Attachment:GetChildren() do
		effect.Enabled = false
	end
	self.Character.Humanoid.WalkSpeed = speed
	self.SpellBook["Meshes/Unrigged"].Transparency = 1
	track.Ended:Wait()
	effects:Destroy()
	humanEffects:Destroy()
	self.Playing = false
	self.SpellBook["Meshes/Unrigged"].Transparency = 0
	BackpackService:Remove(Players:GetPlayerFromCharacter(self.Character), "SpellBook", 1)
	self.Character:RemoveTag("Ignore")
	--BackpackService:Remove()
end

return SpellBook