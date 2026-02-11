local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Night = require(ServerStorage.Classes.Night)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = require(ReplicatedStorage.Modules.functions)

return function()
	local night = Night.new({
		{
			SpawnType = "Ion Battery",
			Amount = functions.goalAmount(5),
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
			SpawnType = "Key",
			Amount = 12
		},
		{
			SpawnType = "Gem",
			Amount = functions.gemAmount(5)
		},
		{
			SpawnType = "Bandage",
			Amount = 7
		},
		{
			SpawnType = "Medkit",
			Amount = 1
		}
	}, 5)
	night:Start({
		"NIGHT 5",
		"Collect ion batteries.",
		"Stay alert in the darkness.",
		"Watch for electric wires.",
		"Don't die."
	})
	for _, v in game:GetService("CollectionService"):GetTagged("Light") do
		if v.Name == "Light" then
			v.BrickColor = BrickColor.new("Really black")
			v.SpotLight.Enabled = false
		end
	end
	ReplicatedStorage.Props.General.Night5ElectricWires.Parent = workspace
	night.Completed:Wait()
end