local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterService = {}

local SetControlsRemote: RemoteEvent = ReplicatedStorage:WaitForChild("Communication")
	:WaitForChild("Character"):WaitForChild("SetControls")

function CharacterService:MoveTo(player: Player, locationId: string)
	if not player or not player.Character then return end

	local taggedParts = CollectionService:GetTagged(locationId)
	if #taggedParts == 0 then return end -- No valid teleport locations

	local targetPart = taggedParts[math.random(#taggedParts)] -- Pick a random part
	local size = targetPart.Size
	local position = targetPart.Position

	-- Compute a random point within the part's bounds
	local randomOffset = Vector3.new(
		math.random() * size.X - size.X / 2,
		3, -- Slightly above to avoid getting stuck
		math.random() * size.Z - size.Z / 2
	)

	local destination = position + randomOffset

	-- Teleport player
	player.Character:PivotTo(CFrame.new(destination))
end

function CharacterService:BatchMoveTo(players: {Player}, locationId: string)
	for _, player in ipairs(players) do
		self:MoveTo(player, locationId)
		task.wait(0.1)
	end
end

function CharacterService:SetWalkSpeed(players: {Player}, walkSpeed: number)
	for _, player in ipairs(players) do
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = if walkSpeed < 0 then player:GetAttribute("WalkSpeed") else walkSpeed
		end
	end
end

function CharacterService:SetControls(players: {Player}, enabled: boolean)
	for _, player in ipairs(players) do
		SetControlsRemote:FireClient(player, enabled)
	end
end

return CharacterService
