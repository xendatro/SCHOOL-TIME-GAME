local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local HttpService = game:GetService("HttpService")

local AudioService = require(ReplicatedStorage.Services.AudioService)

local RewardTable = {
	"Soda",
	"Coin", "Coin", "Coin", "Coin", "Coin",
	"Key",
	"Trap",
	"Bandage", "Bandage", "Bandage"
}


local Locker = {}
Locker.__index = Locker


local setUpConnections = function(self)
	self.Connections = {}
	self.Connections.Touched = self.Locker.Model:FindFirstChild("Plane.061").Touched:Connect(function(hit)
		local key = hit.Parent
		if key == nil then return end
		local character = key.Parent
		if character == nil then return end
		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end
		if key:HasTag("Key") and self.Opened == false then
			self.Opened = true
			BackpackService:Remove(player, "Key", 1)
			local newID = HttpService:GenerateGUID()
			
			AudioService:Add3D(`{newID}`, self.Locker:GetChildren()[1], false, "Locker")
			task.delay(1.2, function()
				AudioService:Remove(`{newID}`)
			end)
			AudioService:Add3D("Key", self.Locker:GetChildren()[1], false, "Key")
			
			local itemWon = math.random(1, 3) == 1
			if itemWon then
				local item = RewardTable[math.random(1, #RewardTable)]
				item = ReplicatedStorage.Props.Spawns[item]:Clone()
				item:PivotTo(self.Locker.SpawnPart:GetPivot() + Vector3.new(0, 2, 0))
				item.Parent = workspace
			end
			for _, instance in self.Locker.Model:GetChildren() do
				if instance:IsA("BasePart") then
					instance.CanCollide = false
					instance.CanQuery = false
				end
			end
			self.Track:Play()
			self.Track:GetMarkerReachedSignal("Opened"):Wait()
			self.Track:AdjustSpeed(0)

		end
	end)
end

function Locker.new(locker: Model)
	local self = setmetatable({}, Locker)
	
	self.Locker = locker
	self.Opened = false
	self.Track = locker.AnimationController.Animator:LoadAnimation(script.Open)
	
	setUpConnections(self)
	
	return self
end

return Locker