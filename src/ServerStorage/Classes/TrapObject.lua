local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local Trap = {}
Trap.__index = Trap

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Trap.Activated.Event:Connect(function()
		self:Close()		
	end)
end

function Trap.new(trap: Model)
	local self = setmetatable({}, Trap)

	self.Trap = trap
	self.Animator = self.Trap.Humanoid.Animator
	self.Track = self.Animator:LoadAnimation(self.Trap.Animations.Trap)
	
	setUpConnections(self)
	
	return self
end

function Trap:Close()
	if self.Trap:GetAttribute("Closed") then return end
	self.Trap:SetAttribute("Closed", true)
	self.Track:Play()
	self.Track:GetMarkerReachedSignal("Finished"):Wait()
	AudioService:Add3D("TrapClose", self.Trap.PrimaryPart, false, "TrapClose")
	self.Track:AdjustSpeed(0)
	Debris:AddItem(self.Trap, 5)
end

return Trap
