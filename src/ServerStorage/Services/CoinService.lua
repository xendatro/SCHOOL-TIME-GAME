local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Update = ReplicatedStorage.Communication.Coins.Update

local CoinsService = {}

CoinsService.Coins = {}
CoinsService.Multipliers = {}

function CoinsService:Create(player: Player, startingAmount: number)
	CoinsService.Coins[player] = startingAmount or 0
	CoinsService:Update(player, {
		NewAmount = 0,
		Show = false
	})
end

function CoinsService:Add(player: Player, amount: number, reason: string?, show: boolean?)
	local oldAmount = CoinsService.Coins[player]
	print(oldAmount)
	print(CoinsService.Multipliers[player])
	CoinsService.Coins[player] += (amount * (CoinsService.Multipliers[player] or 1))
	print(CoinsService.Coins[player])	
	CoinsService:Update(player, {
		NewAmount = CoinsService.Coins[player],
		OldAmount = oldAmount,
		Show = show,
		Reason = reason
	})
end

function CoinsService:Remove(player: Player, amount: number)
	if CoinsService.Coins[player] < amount then return false end
	CoinsService.Coins[player] -= amount
	CoinsService:Update(player, {
		NewAmount = CoinsService.Coins[player],
		Show = false
	})
	return true
end

function CoinsService:Get(player: Player)
	return CoinsService.Coins[player]
end

function CoinsService:Update(player, updateData: {
	OldAmount: number?,
	NewAmount: number,
	Reason: string?,
	Show: boolean
	})
	Update:FireClient(player, updateData)
end

--Triggers
Update.OnServerEvent:Connect(function(player)
	local data = {
		NewAmount = CoinsService:Get(player),
		Show = false
	}
	CoinsService:Update(player, data)
end)

return CoinsService