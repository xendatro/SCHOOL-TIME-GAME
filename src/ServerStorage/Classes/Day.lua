local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CharacterService = require(ServerStorage.Services.CharacterService)
local CurtainService = require(ServerStorage.Services.CurtainService)
local GameService = require(ServerStorage.Services.GameService)
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ObjectiveService = require(ServerStorage.Services.ObjectiveService)
local AudioService = require(ReplicatedStorage.Services.AudioService)

local BadgeService = game:GetService("BadgeService")

local ShopZone = ReplicatedStorage.Props.Other.ShopZone

local Zone = require(ReplicatedStorage.Classes.Zone)

local DayLength = 45

local badges = {
	429290399631207,
	4350721877982536,
	3693081068128505,
	294839833045120
}

local Day = {}
Day.__index = Day

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.ZoneEntered = self.Zone.playerEntered:Connect(function(player)
		ReplicatedStorage.Communication.Shop.Toggle:FireClient(player, true)
	end)
	self.Connections.ZoneExited = self.Zone.playerExited:Connect(function(player)
		ReplicatedStorage.Communication.Shop.Toggle:FireClient(player, false)
	end)
end

function Day.new(day)
	local self = setmetatable({}, Day)
	
	self.ShopZone = ShopZone:Clone()
	self.ShopZone.Parent = workspace
	self.Day = day
	
	self.Zone = Zone.new(self.ShopZone)
	
	setUpConnections(self)
	
	return self
end

function Day:Board()
	for _, v in workspace.ArtRoomPlanks:GetDescendants() do
		if v:IsA("BasePart") then
			v.CanCollide = true
			v.Transparency = 0
		end
	end
end

function Day:Start()
	self:Board()
	
	task.delay(3, function()
		ReplicatedStorage.Communication.Coins.Toggle:FireAllClients(true)		
	end)
	
	local success, err = pcall(function()
		for _, player in GameService.Alive do
			BadgeService:AwardBadge(player.UserId, badges[self.Day])
		end
	end)
	
	--AudioService:Add("Day", "Ambience", true, "DaySound")
	
	
	Lighting.ClockTime = 6
	TweenService:Create(Lighting, TweenInfo.new(DayLength, Enum.EasingStyle.Linear), {
		ClockTime = 18
	}):Play()
	CurtainService:Show(GameService.Alive)
	task.wait(1)
	CharacterService:BatchMoveTo(GameService.Alive, "Shop")
	task.wait(1)
	CurtainService:Hide(GameService.Alive)
	ObjectiveService:Toggle(true)
	ObjectiveService:Update("Prepare", "Purchase items from the shop. Prepare for the next night.")
	self.Time = DayLength
	while self.Time > 0 do
		self.Time -= 1
		if self.Time == 6 then
			AudioService:Remove("Day", true, 5)
		end
		task.wait(1)
	end
	ReplicatedStorage.Communication.Coins.Toggle:FireAllClients(false)
	ReplicatedStorage.Communication.Shop.Toggle:FireAllClients(false)
	self.ShopZone:Destroy()
	ObjectiveService:Toggle(false)
end

return Day