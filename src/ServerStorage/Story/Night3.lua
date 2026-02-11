local ServerStorage = game:GetService("ServerStorage")

local Night = require(ServerStorage.Classes.Night)


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = require(ReplicatedStorage.Modules.functions)

return function()
	local night = Night.new({
		{
			SpawnType = "Computer Chip",
			Amount = functions.goalAmount(3),
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
			Amount = functions.coinAmount(3)
		},
		{
			SpawnType = "Key",
			Amount = 12
		},
		{
			SpawnType = "Gem",
			Amount = functions.gemAmount(3)
		},
		{
			SpawnType = "Bandage",
			Amount = 5
		},
		{
			SpawnType = "Medkit",
			Amount = 1
		}
	}, 3)
	night:Start({
		"NIGHT 3",
		"Collect computer chips.",
		"Complete side quests.",
		"Run from the energized teachers.",
		"Don't die."
	})
	night.Completed:Wait()
	print("done")	
end