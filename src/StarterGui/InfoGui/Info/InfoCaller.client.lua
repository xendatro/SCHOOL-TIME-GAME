local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local showTime = 7

local tweenIn = TweenService:Create(
	script.Parent,
	TweenInfo.new(0.5, Enum.EasingStyle.Back),
	{
		Position = UDim2.fromScale(0.5, 0.2)
	}
)

local tweenOut = TweenService:Create(
	script.Parent,
	TweenInfo.new(0.5, Enum.EasingStyle.Linear),
	{
		Position = UDim2.fromScale(0.5, -0.2)
	}
)

local t = {
	Key = "Use a key to unlock a locker, which sometimes has good loot!",
	Ball = "Throw a paper ball at a teacher to stun them temporarily!",
	Trap = "Place down a trap to temporarily immobilize a teacher!",
	WoodPlank = "Deliver planks to the art room! (Follow the arrows on the wall)",
	Blueprint = "Deliver blueprints to the art room! (Follow the arrows on the wall)",
	["Computer Chip"] = "Deliver computer chips to the art room!",
	Wire = "Deliver wires to the art room!",
	Battery = "Deliver ion batteries to the art room!",
	SpellBook = "Use a spell book to become temporarily immune to damage!",
	Shovel = "Use a shovel to dig to create tunnels through the map!",
	Bandage = "Use a bandage to heal 10 hp!",
	Medkit = "Use a medkit to heal 45 hp!",
	Soda = "Drink a soda for a speed boost.",
	Lantern = "Use a lantern for better visibility!"
}

local Player = Players.LocalPlayer

local completedTable = {}

local key = nil

local function playMessage(message)
	local newKey = {}
	key = newKey
	script.Parent.Position = UDim2.fromScale(0.5, -0.2)
	script.Parent.Info.Text = message
	tweenIn:Play()
	task.wait(showTime)
	if newKey == key then
		tweenOut:Play()
	end
end

Player.Backpack.ChildAdded:Connect(function(child)
	local name = child.Name
	if completedTable[name] then return end
	if t[name] == nil then return end
	completedTable[name] = true
	playMessage(t[name])
end)

ReplicatedStorage.Communication.InfoCaller.Message.OnClientEvent:Connect(function(message)
	playMessage(message)
end)