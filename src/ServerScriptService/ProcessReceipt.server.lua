local MarketplaceService = game:GetService("MarketplaceService")
local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local GameService = require(ServerStorage.Services.GameService)
local GemService = require(ServerStorage.Services.GemService)
local CoinsService = require(ServerStorage.Services.CoinService)
local BackpackService = require(ServerStorage.Services.BackpackService)
local DownService = require(ServerStorage.Services.DownService)

local reviveTable = {

}

local t = {
	[3257471245] = function(player)
		GemService:Add(player, 5)
	end,
	[3257471247] = function(player)
		GemService:Add(player, 15)
	end,
	[3257471243] = function(player)
		GemService:Add(player, 35)
	end,
	[3257471241] = function(player)
		GemService:Add(player, 100)
	end,
	[3257471240] = function(player)
		GemService:Add(player, 220)
	end,
	[3260078201] = function(player)
		if reviveTable[player] then
			if table.find(GameService.Alive, player) then return end
			GameService:Add(reviveTable[player], true)		
		end
	end,
	[3260358801] = function(player)
		CoinsService:Add(player, 100)
	end,
	[3266604586] = function(player)
		for _, v in Players:GetPlayers() do
			ReplicatedStorage.Communication.Jumpscare.Play:FireClient(v, player)
		end
	end,
	[3285232563] = function(player)
		DownService:Up(player.Character)
	end,
	[3526495198] = function(player)
		CoinsService:Add(player, 10)  
	end,

}


ReplicatedStorage.Communication.Revive.Set.OnServerEvent:Connect(function(player, player2)
	reviveTable[player] = player2
end)

ReplicatedStorage.Communication.Spectate.SetFocus.OnServerEvent:Connect(function(player, playerToSpectate)
	player.ReplicationFocus = playerToSpectate.Character.PrimaryPart
end)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local id = receiptInfo.ProductId
	if t[id] then 
		t[id](Players:GetPlayerByUserId(receiptInfo.PlayerId))
	end
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Handle rewarded video ad requests from client
ReplicatedStorage.Communication.Ads.Reward.OnServerEvent:Connect(function(player)
	local isSuccess, result = pcall(function()
		local reward = AdService:CreateAdRewardFromDevProductId(3526495198)
		return AdService:ShowRewardedVideoAdAsync(player, reward)
	end)
	
	-- Fire back to client with result
	ReplicatedStorage.Communication.Ads.Reward:FireClient(player, isSuccess, result)
	
	if isSuccess then
		print("Ad shown to", player.Name, "- Result:", result)
	else
		warn("Failed to show ad to", player.Name, "- Error:", result)
	end
end)
