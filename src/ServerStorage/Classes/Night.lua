local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SpawnService = require(ServerStorage.Services.SpawnService)
local GameService = require(ServerStorage.Services.GameService)
local ObjectService = require(ReplicatedStorage.Services.ObjectService)
local BackpackService = require(ServerStorage.Services.BackpackService)
local CurtainService = require(ServerStorage.Services.CurtainService)
local AudioService = require(ReplicatedStorage.Services.AudioService)
local ObjectiveService = require(ServerStorage.Services.ObjectiveService)
local TextChatService = game:GetService("TextChatService")

local Antagonist = require(ServerStorage.Antagonist.Antagonist)

local Deliver = ReplicatedStorage.Props.General.Deliver

type SpawnInfo = {
	SpawnType: string,
	Amount: number,
	IsGoal: boolean?
}

local Signal = require(ReplicatedStorage.Classes.Signal)


local function spawnItems(self)
	local aliveCount = #GameService.Alive
	
	local points = nil
	for _, spawnInfo: SpawnInfo in self.Items do
		local params: SpawnService.SpawnParams = {
			SpawnType = spawnInfo.SpawnType,
			SpawnPoints = points or ObjectService:GetInstancesOfClassName("Spawn"),
			OldItemType = spawnInfo.SpawnType,
			Amount = spawnInfo.Amount
		}
		
		local spawnData = SpawnService:Spawn(params)
		points = spawnData.UnusedSpawnPoints
		if spawnInfo.IsGoal then
			self.Goals = spawnData.Spawns
			self.GoalType = spawnInfo.SpawnType
			self.Needed = spawnInfo.Amount
		end
		task.wait()
	end
	self.UnusedPoints = points
end
--[[
local function spawnGoals(self)
	local function spawnByAmount(amount: number) 
		local params: SpawnService.SpawnParams = {
			SpawnType = self.GoalData.SpawnType,
			SpawnPoints = self.UnusedSpawnPoints,
			Amount = amount
		}

		local spawnData = SpawnService:Spawn(params)
		self.Goals = spawnData.Spawns
		self.UnusedSpawnPoints = spawnData.UnusedSpawnPoints
	end
	
	spawnByAmount(self.GoalData.Amount)
	
	coroutine.create(function() --spawn the necessary amount after a while and maybe highlight them too
		
	end)
end]]

local function createDeliver(self)
	self.Deliver = Deliver:Clone()
	self.Deliver.Parent = workspace
	self.Deliver.Deliver.ActionText = `Place your {self.GoalType} here!`
end

local function updateDelivered(self)
	ReplicatedStorage.Communication.Goal.Update:FireAllClients({
		GoalType = self.GoalType,
		GoalCurrentAmount = self.Delivered,
		GoalAmount = self.Needed
	})
	if self.Delivered >= self.Needed then
		print("should be")
		self:Complete()
	end
end

local function deliver(self, player)
	local amount = BackpackService:RemoveAll(player, self.GoalType)
	print(self.GoalType)
	self.Delivered += amount
	print(self.Delivered)
	updateDelivered(self)
end

local function setUpConnections(self)
	self.Connections.Deliver = self.Deliver.Deliver.Triggered:Connect(function(player: Player)
		deliver(self, player)
	end)
	self.Connections.Override = TextChatService.Skip.Triggered:Connect(function(source)
		if source.Name == "xendatro" then
			self.Delivered = self.Needed
			updateDelivered(self)
		end		
	end)
end

local function planks(isNight1)
	for _, v in workspace.ArtRoomPlanks:GetDescendants() do
		if v:IsA("BasePart") then
			print("yeah")
			v.CanCollide = false
			v.Transparency = if isNight1 then 1 else 0.8
		end
	end
end

local Night = {}
Night.__index = Night

local t = {"WoodPlank", "Blueprint", "Computer Chip", "Wire", "Ion Battery"}

function Night.new(items: {SpawnInfo}, night)
	local self = setmetatable({}, Night)
	
	self.Completed = Signal.new()
	self.Items = items
	self.Delivered = 0
	self.Night = night
	self.GoalType = items[1].SpawnType
	self.Needed = items[1].Amount
		
	self.Connections = {}
	
	
	self:Initialize()
	setUpConnections(self)
	
	return self
end

function Night:Initialize()
	game.Lighting.ClockTime = 2
	task.spawn(function()
		spawnItems(self)	
		
	end)
	createDeliver(self)
	planks(self.GoalType == "WoodPlank")
end

function Night:Start(nightMessages)
	AudioService:Add("Background", "Ambience", true, "Background")
	for _, player in GameService.Alive do
		ReplicatedStorage.Communication.Night.ShowMessages:FireClient(player, nightMessages)		
	end
	local folder = ReplicatedStorage.Props.Nights[`Night{self.Night}`]
	

	self.Antagonists = {}
	for _, v in folder:GetChildren() do
		local clone = v:Clone()
		clone.Parent = workspace
		table.insert(self.Antagonists, clone)
		Antagonist.new(clone):Start()
	end
	
	CurtainService:Hide(game:GetService("Players"):GetPlayers())
	ReplicatedStorage.Communication.Goal.Update:FireAllClients({
		GoalType = self.GoalType,
		GoalCurrentAmount = self.Delivered,
		GoalAmount = self.Needed
	})
	ReplicatedStorage.Communication.Goal.Toggle:FireAllClients(true)
	self.IsComplete = false
	
	ObjectiveService:Toggle(true)
	local text = self.GoalType
	if self.GoalType == "WoodPlank" then
		text = "Wood Plank"
	end
	ObjectiveService:Update(`Collect {text}`, `Find {text} and deliver them at the art room (follow the red arrows on the wall).`)
	CurtainService:Hide(game:GetService("Players"):GetPlayers())
	self.SpawnMoreEngine = coroutine.create(function()
		while task.wait(20) do
			local params: SpawnService.SpawnParams = {
				SpawnType = self.GoalType,
				SpawnPoints = self.UnusedPoints,
				Amount = 1
			}
			SpawnService:Spawn(params)
		end
	end)
	coroutine.resume(self.SpawnMoreEngine)
end

function Night:Complete()
	if self.IsComplete then return end
	self.Deliver:Destroy()
	for _, v in self.Antagonists do
		v:Destroy()
	end
	self.IsComplete = true
	self.Completed:Fire()
	coroutine.close(self.SpawnMoreEngine)
	AudioService:Remove("Background", true, 3)
	ReplicatedStorage.Communication.Goal.Toggle:FireAllClients(false)
	ObjectiveService:Toggle(false)
	
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	
	for _, object in ObjectService:GetInstancesOfClassName("Grab", workspace) do
		object:Destroy()
	end
	
	for _, player in GameService.Alive do
		BackpackService:RemoveAll(player, t[self.Night])
	end
end

return Night 