local ServerStorage = game:GetService("ServerStorage")

local Night = require(ServerStorage.Classes.Night)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = require(ReplicatedStorage.Modules.functions)

return function()
	local night = Night.new({
		{
			SpawnType = "Blueprint",
			Amount = functions.goalAmount(2),
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
			Amount = functions.coinAmount(2)
		},
		{
			SpawnType = "Key",
			Amount = functions.gemAmount(2)
		},
		{
			SpawnType = "Gem",
			Amount = 1
		},
		{
			SpawnType = "Bandage",
			Amount = 4
		},
		{
			SpawnType = "Medkit",
			Amount = 1
		}
	}, 2)
	night:Start({
		"NIGHT 2",
		"Collect blueprints.",
		"Unlock lockers with keys.",
		"Run from the principal.",
		"Don't die."
	})
	night.Completed:Wait()
	print("done")	
end