local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Set = ReplicatedStorage.Communication.Hunger.Set

local Hunger = {}
Hunger.__index = Hunger

local Decrement = 1
local Time = 2

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Died = self.Character:WaitForChild("Humanoid").Died:Connect(function()
		self:Destroy()
	end)
end

function Hunger.new(player: Player)
	local self = setmetatable({}, Hunger)
	
	self.Value = 100
	self.Player = player
	self.Character = player.Character or player.CharacterAdded:Wait()
	
	setUpConnections(self)
	
	return self	
end

function Hunger:Resume()
	self.Engine = coroutine.create(function()
		while task.wait(Time) do
			if self.Value == 0 then
				-- some sort of death thing
			else
				self:Subtract(Decrement)
			end
		end
	end)
	coroutine.resume(self.Engine)
end

function Hunger:Set(n: number)
	self.Value = math.round(math.clamp(n, 0, 100))
	
	--fire remote event here
	Set:FireClient(self.Player, self.Value)
end

function Hunger:Add(n: number)
	self:Set(self.Value + n)
end

function Hunger:Subtract(n: number)
	self:Set(self.Value - n)
end

function Hunger:Pause()
	if self.Engine then
		coroutine.close(self.Engine)
	end
end

function Hunger:Destroy()
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	table.clear(self)
end

return Hunger