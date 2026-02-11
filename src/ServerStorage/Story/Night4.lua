local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Night = require(ServerStorage.Classes.Night)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = require(ReplicatedStorage.Modules.functions)

return function()
	local night = Night.new({
		{
			SpawnType = "Wire",
			Amount = functions.goalAmount(4),
			IsGoal = true
		},
		{
			SpawnType = "Shovel",
			Amount = 1
		},
		{
			SpawnType = "Soda",
			Amount = 6
		},
		{
			SpawnType = "SpellBook",
			Amount = 2
		},
		{
			SpawnType = "Trap",
			Amount = 5
		},
		{
			SpawnType = "Ball",
			Amount = 3
		},
		{
			SpawnType = "Coin",
			Amount = functions.coinAmount(4)
		},
		{
			SpawnType = "Key",
			Amount = 12
		},
		{
			SpawnType = "Gem",
			Amount = functions.gemAmount(4)
		},
		{
			SpawnType = "Bandage",
			Amount = 7
		},
		{
			SpawnType = "Medkit",
			Amount = 1
		}
	}, 4)
	
	night:Start({
		"NIGHT 4",
		"Collect wire coils.",
		"Use resources wisely.",
		"Avoid decoy lockers.",
		"Don't die."
	})
	
	ReplicatedStorage.Props.General.Night4Lockers.Parent = workspace
	
	night.Completed:Wait()
	print("done")	
end