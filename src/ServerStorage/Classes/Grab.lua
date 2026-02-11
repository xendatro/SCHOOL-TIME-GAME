local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local CoinService = require(ServerStorage.Services.CoinService)
local GemService = require(ServerStorage.Services.GemService)

local AudioService = require(ReplicatedStorage.Services.AudioService)

local GrabPrompt = ReplicatedStorage.Props.Prompts.GrabPrompt

local Grab = {}
Grab.__index = Grab

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Triggered = self.Prompt.Triggered:Connect(function(player: Player)
		if not player.Character or player.Character:HasTag("Downed") then return end
		if self.Grab:GetAttribute("Type") == "Coin" then
			AudioService:Add3D("PickupCoin", player.Character.PrimaryPart, false, "Coin", 0.1)
			CoinService:Add(player, 1, "Picked up coin!", true)
		elseif self.Grab:GetAttribute("Type") == "Gem" then
			AudioService:Add3D("PickupGem", player.Character.PrimaryPart, false, "Gem")
			GemService:Add(player, 1)
		else
			local add = BackpackService:Add(player, self.Grab:GetAttribute("Type"), 1)
			if add == false then 
				ReplicatedStorage.Communication.InfoCaller.Message:FireClient(player, `Can't hold more than {BackpackService.Maxes[player] or 10} items! Hit BACKSPACE to drop items.`)
				return
			end
			AudioService:Add3D("Grab", player.Character.PrimaryPart, false, "Grab")
		end
		self:Destroy()
	end)
end

function Grab.new(grab: BasePart | Model)
	local self = setmetatable({}, Grab)
	self.Grab = grab
	self.Prompt = GrabPrompt:Clone()
	if self.Grab:IsA("Model") then
		self.Prompt.Parent = self.Grab.PrimaryPart
	else
		self.Prompt.Parent = self.Grab
	end
	
	self.Prompt.ObjectText = self.Grab.Name
	self.Prompt.ActionText = self.Grab:GetAttribute("ActionText")
	
	setUpConnections(self)
	
	return self
end

function Grab:Destroy()
	self.Grab:Destroy()
	table.clear(self)
end

return Grab