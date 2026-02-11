
local ServerStorage = game:GetService("ServerStorage")

local Night = require(ServerStorage.Classes.Night)

local Antagonist = require(ServerStorage.Antagonist.Antagonist)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = require(ReplicatedStorage.Modules.functions)

--[[
cutscene 1
chase find wooden planks
board up in that room
cutscene 2 plays
day 2 plays
chase find blueprints
cutscene 3 plays
day 3 plays
chase find chips
cutscene 4 plays (POWER IS NOW OUT)
day 4 plays
chase find POWER CELLS
AT THE END, MAKE IT SO THE PLAYERS PUT IN THE POWERCELLS, USE THE CHIPS AND ESCAPE
cutscene 5
]]


return function()
	local night = Night.new({
		{
			SpawnType = "WoodPlank",
			Amount = functions.goalAmount(1),
			IsGoal = true
		},
		{
			SpawnType = "Soda",
			Amount = 5
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
			Amount = 4
		},
		{
			SpawnType = "Coin",
			Amount = functions.coinAmount(1)
		},
		{
			SpawnType = "Key",
			Amount = 12
		},
		{
			SpawnType = "Gem",
			Amount = functions.gemAmount(1)
		},
		{
			SpawnType = "Bandage",
			Amount = 3
		},
		{
			SpawnType = "Medkit",
			Amount = 1
		}
	}, 1)
	night:Start({
		"NIGHT 1",
		"Collect wooden planks.",
		"Find items for safety.",
		"Run from the teacher.",
		"Don't die."
	})
	night.Completed:Wait()
	print("done")
end