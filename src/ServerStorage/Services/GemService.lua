local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataSaveService = require(ServerStorage.Services.DataSaveService)
local Players = game:GetService("Players")

local GemService = {}

GemService.Multipliers = {}

function GemService:Add(player: Player, amount: number)
	local data = DataSaveService:Get(player)
	if data == nil then return end
	data.Gems += (amount * (GemService.Multipliers[player] or 1))
	GemService:Update(player)
end

function GemService:Remove(player: Player, amount: number): boolean
	local data = DataSaveService:Get(player)
	if data == nil then return false end
	if data.Gems >= amount then
		data.Gems -= amount
		GemService:Update(player)
		return true
	end
	return false
end

function GemService:Get(player: Player)
	local data = DataSaveService:Get(player)
	if data == nil then return false end
	return data.Gems
end

function GemService:Update(player: Player)
	print(player)
	local gems = GemService:Get(player)
	print(gems)
	if not gems then return end
	ReplicatedStorage.Communication.Gems.Update:FireClient(player, gems)
end

Players.PlayerAdded:Connect(function(player)
	local loaded = false
	local count = 0
	repeat 
		task.wait(1)
		loaded = DataSaveService:Has(player)
		count += 1
	until count >= 10 or loaded
	if not loaded then
		warn("Issue loading data.")
		return
	end
	GemService:Update(player)
end)

return GemService