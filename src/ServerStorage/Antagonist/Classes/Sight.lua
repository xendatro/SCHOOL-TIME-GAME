local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Signal = require(script.Parent.Parent.Classes.Signal)

local Sight = {}
Sight.__index = Sight

export type SightConfig = {
	Distance: number,
	FOV: number,
	Head: BasePart,
	Antagonist: Model
}

local function isSpotted(self, player: Player)
	if player.Character == nil then return end

	self.Params.FilterDescendantsInstances = game:GetService("CollectionService"):GetTagged("Ignore")
	local lookvector = self.Config.Head.CFrame.LookVector
	if not player.Character or not player.Character.PrimaryPart then return end
	local dirvector = player.Character.PrimaryPart.Position - self.Config.Head.Position
	local dot = lookvector:Dot(dirvector)
	local angle = math.deg(math.acos(dot/(lookvector.Magnitude*dirvector.Magnitude)))
	if angle > self.Config.FOV/2 then return end
	local initPosition = self.Config.Head.CFrame.Position
	local result = workspace:Raycast(
		initPosition,
		(player.Character.PrimaryPart.Position - initPosition).Unit * self.Config.Distance,
		self.Params
	)
	if result == nil then return end
	if not result.Instance:IsDescendantOf(player.Character) then return end
	return player.Character, result.Distance
end

local function calculateSpotted(self)
	local closestCharacter, closestDistance = nil, nil
	for _, player in Players:GetPlayers() do
		local character, distance = isSpotted(self, player)
		if character == nil then continue end
		if closestDistance == nil or distance < closestDistance then
			closestCharacter = character
			closestDistance = distance
		end
	end
	return closestCharacter
end

local function start(self)
	self.SightEngine = coroutine.create(function()
		while RunService.Heartbeat:Wait() do
			local spotted = calculateSpotted(self)
			local lastSpotted = self.Spotted
			self.Spotted = spotted
			if lastSpotted ~= spotted then
				self.Changed:Fire(spotted)
			end
		end
	end)
	
	coroutine.resume(self.SightEngine)
end

function Sight.new(sightConfig: SightConfig)
	local self = setmetatable({}, Sight)
	
	self.Config = sightConfig
	self.Spotted = nil
	
	self.Params = RaycastParams.new()
	self.Params.FilterType = Enum.RaycastFilterType.Exclude
	
	self.Changed = Signal.new()
	
	start(self)
	
	return self
end

function Sight:Destroy()
	if self.SightEngine then
		coroutine.close(self.SightEngine)
	end
end

return Sight