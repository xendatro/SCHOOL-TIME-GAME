local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ObjectService = require(ReplicatedStorage.Services.ObjectService)

local SpawnService = {}

export type SpawnParams = {
	SpawnType: string, --links up to a grabbable item in RepStorage->Props->Spawns
	SpawnPoints: {Part},
	Amount: number, 
	OldItemType: string? --Type of item to destroy
}

export type SpawnData = {
	UsedSpawnPoints: {Part},
	UnusedSpawnPoints: {Part},
	Spawns: {Instance}
}


function SpawnService:Spawn(spawnParams: SpawnParams): SpawnData
	local spawnItem = ReplicatedStorage.Props.Spawns:FindFirstChild(spawnParams.SpawnType)
	if spawnItem == nil then return end
	if spawnParams.OldItemType then
		for _, item in ObjectService:GetInstancesOfClassName("Grab", workspace) do
			if item:GetAttribute("Type") ~= spawnParams.OldItemType then continue end
			item:Destroy()
		end
	end
	local spawns = table.clone(spawnParams.SpawnPoints)
	local usedSpawnPoints = {}
	local items = {}
	for i = 1, spawnParams.Amount do
		local spawnPoint = table.remove(spawns, math.random(1, #spawns))
		local item = spawnItem:Clone()
		item:PivotTo(spawnPoint.CFrame + Vector3.new(0, 2, 0))
		item.Parent = workspace
		table.insert(usedSpawnPoints, spawnPoint)
		table.insert(items, item)
		print(item)
		task.wait()
	end
	return {
		UsedSpawnPoints = usedSpawnPoints,
		UnusedSpawnPoints = spawns,
		Spawns = items
	}
end

return SpawnService