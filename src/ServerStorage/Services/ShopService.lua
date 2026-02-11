local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local CoinService = require(ServerStorage.Services.CoinService)


local Purchase = ReplicatedStorage.Communication.Shop.Purchase

local ShopSettings = require(ReplicatedStorage.Settings.ShopSettings)

local ShopService = {}


function ShopService:Purchase(player: Player, itemName: string, quantity: number)
	local amount = ShopSettings:GetPriceFromQuantity(itemName, quantity)
	if BackpackService:GetQuantity(player) >= (BackpackService.Maxes[player] or 10) then
		ReplicatedStorage.Communication.InfoCaller.Message:FireClient(player, "Can't hold more than 10 items! Hit BACKSPACE to drop items. ")
		return	
	end
	if CoinService:Remove(player, amount) then
		BackpackService:Add(player, itemName, quantity)
		--send notification here
	end
end

--Triggers
Purchase.OnServerEvent:Connect(function(player: Player, itemName: string)
	ShopService:Purchase(player, itemName, 1)
end)

return ShopService