local ServerStorage = game:GetService("ServerStorage")
local ProfileService = require(ServerStorage.Services.ProfileService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataTemplate = {
	Gems = 0,
	Kits = {},
	Wins = 0
}

local PlayerDataStore = ProfileService.New("PlayerDataStore", PlayerDataTemplate)
local Profiles: {[player]: typeof(PlayerDataStore:StartSessionAsync())} = {}

local DataSaveService = {}

function DataSaveService:Create(player)
	-- Start a profile session for this player's data:

	local profile = PlayerDataStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:

	if profile ~= nil then

		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			Profiles[player] = profile
			print(`Profile loaded for {player.DisplayName}!`)
			
			local leaderstats = Instance.new("Folder")
			leaderstats.Name = "leaderstats"
			local winsStat = Instance.new("IntValue")
			winsStat.Value = profile.Data.Wins
			winsStat.Name = "Wins"
			winsStat.Parent = leaderstats

			leaderstats.Parent = player
			-- EXAMPLE: Grant the player 100 coins for joining:
			--profile.Data.Cash += 100
			-- You should set "Cash" in PROFILE_TEMPLATE and use "Profile:Reconcile()",
			-- otherwise you'll have to check whether "Data.Cash" is not nil
			
		else
			-- The player has left before the profile session started
			profile:EndSession()
		end

	else
		-- This condition should only happen when the Roblox server is shutting down
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

function DataSaveService:Delete(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end

function DataSaveService:Get(player)
	return Profiles[player].Data
end

function DataSaveService:Has(player)
	return if Profiles[player] then true else false
end

Players.PlayerAdded:Connect(function(player)
	DataSaveService:Create(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataSaveService:Delete(player)
end)

for _, player in Players:GetPlayers() do
	DataSaveService:Create(player)
end

return DataSaveService