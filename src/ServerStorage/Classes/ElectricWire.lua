local Players = game:GetService("Players")

local ElectricWire = {}
ElectricWire.__index = ElectricWire

local function setUpConnections(self)
	self.Connections = {}
	
	self.Connections.Touched = self.Main.Touched:Connect(function(hit)
		if self.Active == false then return end
		if hit.Parent:HasTag("Ignore") then return end
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player then return end
		if self.CoolingTable[player] then return end
		self.CoolingTable[player] = true
		
		local humanoid = hit.Parent.Humanoid
		
		humanoid:TakeDamage(20)
		humanoid.Sit = true
		
		task.delay(1, function()
			humanoid.Sit = false
		end)
		
		
		task.wait(self.Cooldown)
		self.CoolingTable[player] = nil
	end)
end

function ElectricWire.new(wire: Model)
	local self = setmetatable({}, ElectricWire)
	
	self.Wire = wire
	self.Main = wire.Main
	self.Electric = wire.Electric
	
	self.Damage = 20
	
	self.Active = false
	
	self.RestTime = 20
	self.ActiveTime = 10
	
	self.Cooldown = 3
	self.CoolingTable = {}
	
	setUpConnections(self)
	
	self:Start()
	
	return self
end

function ElectricWire:Start()
	self.Engine = coroutine.create(function()
		task.wait(math.random(0, 20))
		while true do
			self:On()
			task.wait(self.ActiveTime)
			self:Off()
			task.wait(self.RestTime)
		end
	end)
	
	coroutine.resume(self.Engine)
end

function ElectricWire:On()
	for _, v in self.Electric:GetChildren() do
		v.Enabled = true
	end
	task.wait(1)
	self.Active = true
end

function ElectricWire:Off()
	for _, v in self.Electric:GetChildren() do
		v.Enabled = false
	end
	self.Active = false
end

return ElectricWire