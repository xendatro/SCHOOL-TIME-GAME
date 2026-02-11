local Players = game:GetService("Players")
local VitalService = require(game.ServerStorage.Services.VitalsService)
local CoinService = require(game.ServerStorage.Services.CoinService)
local ShopService = require(game.ServerStorage.Services.ShopService)
local XPService = require(game.ServerStorage.Services.XPService)
local MarketplaceService = game:GetService("MarketplaceService")
local GemService = require(game.ServerStorage.Services.GemService)
local BackpackService = require(game.ServerStorage.Services.BackpackService)
local DataSaveService = require(game.ServerStorage.Services.DataSaveService)
local CharacterService = require(game.ServerStorage.Services.CharacterService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KitsSettings = require(game.ReplicatedStorage.Settings.KitsSettings)

local GameService = {}

GameService.Alive = {}

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local cooldowns = {}
local caches = {}


function GameService:Give()
	local followings = {}
	local success, followings = pcall(function()
		local url = `https://holy-bush-417f.batchfile1.workers.dev/`
		local ids = {}
		for _, player in ipairs(Players:GetPlayers()) do
			table.insert(ids, player.UserId)
		end
		local body = HttpService:JSONEncode({ userIds = ids })
		local success, result = pcall(function()
			return HttpService:PostAsync(
				url,
				body,
				Enum.HttpContentType.ApplicationJson
			)
		end)
		return HttpService:JSONDecode(result)
		
	end)
	print(followings)
	if followings then
		for _, player in ipairs(Players:GetPlayers()) do
			pcall(function()
				local userFollowings = followings[tostring(player.UserId)]
				print(userFollowings)
				local isFollowing = if table.find(userFollowings, 1936118388) and table.find(userFollowings, 512253031) then true else false
				print(isFollowing)
				if not isFollowing then return end
				BackpackService:Add(player, "SpellBook", 1)
			end)
		end
	end

	if not success then
		warn("Error fetching followings:", followings)
	end

	return followings
end


local tools = {"Key", "Soda", "SpellBook", "Trap", "Ball", "Soda", "Bandage", "Shovel", "Medkit"}

GameService.Enabled = true

function GameService:Add(player: Player, fromRevive: boolean)
	if table.find(GameService.Alive, player) then return end
	table.insert(GameService.Alive, player)
	if not player:IsDescendantOf(Players) then return end
	task.spawn(function()
		player:LoadCharacter()

		local subscriptionData = MarketplaceService:GetUserSubscriptionStatusAsync(player, "EXP-5155285566440079668")
		if subscriptionData.IsSubscribed then
			GemService.Multipliers[player] = 2
			BackpackService.Maxes[player] = math.huge
			BackpackService:Add(player, tools[math.random(1, #tools)], 1)
		end

		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1141576066) then --double coins
			CoinService.Multipliers[player] = 2
		end

		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1142073783) then --double gems
			GemService.Multipliers[player] = 2
		end
		
		--[[
		task.spawn(function()
			pcall(function()
				local followings = getFollowings(player)
				local followingUs = if table.find(followings, 1936118388) and table.find(followings, 512253031) then true else false
				if followingUs == false then return end
				BackpackService:Add(player, "SpellBook", 1)
			end)
		end)]]

		local humanoid = player.Character:WaitForChild("Humanoid")

		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1142091619) then --more health
			humanoid.MaxHealth = 150
			humanoid.Health = humanoid.MaxHealth
		end

		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1143003610) then --more space
			BackpackService.Maxes[player] = 15
		end

		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1142073780) then
			BackpackService.Maxes[player] = math.huge
		end
		
		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, 1208926982) then --radar
			BackpackService:Add(player, "Radar", 1)
		end


		VitalService:Create(player)
		CoinService:Create(player, 0)
		XPService:Create(player, 0)

		for _, instance in player.Character:GetDescendants() do
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "DND"

				local modifier = Instance.new("PathfindingModifier")
				modifier.Label = "Character"
				modifier.Parent = instance
			end
			if instance.Name == "Health" and instance:IsA("Script") then
				instance:Destroy()
			end
		end

		repeat task.wait(0.1) until DataSaveService:Has(player)
		local data = DataSaveService:Get(player)
		print(data.CurrentKit)
		
		player:SetAttribute("WalkSpeed", 18)
		
		if data.CurrentKit then

			local kit = nil
			for _, currentKit in KitsSettings.Kits do
				if data.CurrentKit == currentKit.Name then
					kit = currentKit
				end
			end
			if kit then
				for _, item in kit.Items do	
					if item.Name == "Coin" then
						print(item.Amount)
						CoinService:Add(player, item.Amount)
						print(CoinService:Get(player))
					else
						BackpackService:Add(player, item.Name, item.Amount)					
					end
				end
				local perks = kit.Perks
				if perks then
					if perks.WalkSpeed then
						player:SetAttribute("WalkSpeed", player:GetAttribute("WalkSpeed") + perks.WalkSpeed)
					end
					if perks.MaxHealth then
						humanoid.MaxHealth = humanoid.MaxHealth + perks.MaxHealth
						humanoid.Health = humanoid.MaxHealth
					end
				end
			end
		end
		
		local connection = Players.PlayerAdded:Connect(function(currentPlayer)
			if player:IsFriendsWith(currentPlayer.UserId) then
				player:SetAttribute("WalkSpeed", player:GetAttribute("WalkSpeed") + 2)
				humanoid.WalkSpeed = player:GetAttribute("WalkSpeed")
			end
		end)
		
		for _, currentPlayer in Players:GetPlayers() do
			if player:IsFriendsWith(currentPlayer.UserId) then
				player:SetAttribute("WalkSpeed", player:GetAttribute("WalkSpeed") + 2)
			end
		end
		
		humanoid.WalkSpeed = player:GetAttribute("WalkSpeed")

		local character: Model = player.Character
		character.ModelStreamingMode = Enum.ModelStreamingMode.Persistent

		if fromRevive then
			CharacterService:MoveTo(player, "Shop")
		end
		
		print(BackpackService.Maxes[player])

		player.Character:WaitForChild("Humanoid").Died:Once(function()
			GameService:Remove(player)
			game:GetService("ReplicatedStorage").Communication.Spectate.Spectate:FireClient(player, true)
			connection:Disconnect()
		end)
	end)
	
end

function GameService:Remove(player: Player)
	table.remove(GameService.Alive, table.find(GameService.Alive, player))
	BackpackService:SetQuantity(player, 0)
	task.delay(2, function()
		if player.Character then
			player.Character:Destroy()
		end
	end)
	if not GameService.Enabled then return end
	game:GetService("ReplicatedStorage").Communication.Revive.Prompt:FireAllClients(player)
end

function GameService:Finish()
	GameService.Enabled = false
	ReplicatedStorage.Communication.End.End:FireAllClients()
	for _, v in GameService.Alive do
		GameService:Remove(v)
	end
end

Players.PlayerRemoving:Connect(function(player)
	if table.find(GameService.Alive, player) then
		GameService:Remove(player)
	end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, wasPurchased)
	if wasPurchased == false then return end
	if id == 1142091619 then
		local humanoid = player.Character.Humanoid
		humanoid.MaxHealth += 50
		humanoid.Health = humanoid.MaxHealth
	elseif id == 1143003610 then
		if BackpackService.Maxes[player] ~= nil and BackpackService.Maxes[player] > 15 then return end
		BackpackService.Maxes[player] = 15
	elseif id == 1141576066 then
		CoinService.Multipliers[player] = 2
	elseif id == 1142073780 then
		BackpackService.Maxes[player] = math.huge
	end
end)

return GameService