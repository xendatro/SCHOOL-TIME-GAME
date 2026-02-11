local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Update = ReplicatedStorage.Communication.XP.Update

local XPService = {}

XPService.XP = {}

function XPService:Create(player: Player, startingAmount: number)
	XPService.XP[player] = startingAmount or 0
	XPService:Update(player, {
		NewAmount = 0,
		Show = false
	})
end

function XPService:Add(player: Player, amount: number, reason: string?, show: boolean?)
	local oldAmount = XPService.XP[player]
	XPService.XP[player] += amount
	XPService:Update(player, {
		NewAmount = XPService.XP[player],
		OldAmount = oldAmount,
		Show = show,
		Reason = reason
	})
end

function XPService:Remove(player: Player, amount: number)
	if XPService.XP[player] < amount then return false end
	XPService.XP[player] -= amount
	XPService:Update(player, {
		NewAmount = XPService.XP[player],
		Show = false
	})
	return true
end

function XPService:Get(player: Player)
	return XPService.XP[player]
end

function XPService:Update(player, updateData: {
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
		NewAmount = XPService:Get(player),
		Show = false
	}
	XPService:Update(player, data)
end)

return XPService