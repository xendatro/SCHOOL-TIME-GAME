local ServerStorage = game:GetService("ServerStorage")
local SpawnService = require(ServerStorage.Services.SpawnService)
local GameService = require(ServerStorage.Services.GameService)
local VitalsService = require(ServerStorage.Services.VitalsService)
local XPService = require(ServerStorage.Services.XPService)
local CurtainService = require(ServerStorage.Services.CurtainService)

local Antagonist = require(ServerStorage.Antagonist.Antagonist)

--Antagonist.new(workspace.Teacher):Start()
--Antagonist.new(workspace.Principal):Start()

require(game.ServerStorage.Modules.objectifier)()
require(game.ServerStorage.Modules.trigger)()
require(game.ServerStorage.Modules.tooltagger)()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local t = 20

local amount = nil

local data = nil
local skip = false

local waiting = false

Players.PlayerAdded:Connect(function(player)
	if not data then
		data = player:GetJoinData().TeleportData
		if data then
			amount = data.Amount	
		else
			skip = true
		end
	end
	if waiting then
		GameService:Add(player)
		ReplicatedStorage.Communication.Load.Done:FireClient(player)
		ReplicatedStorage.Communication.StartingIn.Toggle:FireClient(player)
	end
end)

repeat task.wait(0.1) until amount ~= nil or skip

if amount then
	repeat task.wait(0.1) until os.clock() - t >= 7 or amount == #game:GetService("Players"):GetPlayers()	
	task.wait(2)
end

for _, player in Players:GetPlayers() do
	GameService:Add(player)
end

waiting = true
ReplicatedStorage.Communication.Load.Done:FireAllClients()

ReplicatedStorage.Communication.StartingIn.Toggle:FireAllClients(true)

task.delay(2, function()
	GameService:Give()
end)

local t = 25
while t > 0 do
	ReplicatedStorage.Communication.StartingIn.Update:FireAllClients(t)
	task.wait(1)
	t -= 1
end

ReplicatedStorage.Communication.StartingIn.Toggle:FireAllClients(false)

CurtainService:Show(Players:GetPlayers())

task.wait(1)


--[[
local firstPlayer = Players.PlayerAdded:Wait()
local data = firstPlayer:GetJoinData().TeleportData
if data then
	amount = data.Amount
	
	local initTime = os.clock()
	repeat task.wait(0.1) until os.clock() - t >= 20 or amount == #game:GetService("Players"):GetPlayers()

end	
task.wait(10)

ReplicatedStorage.Communication.Load.Done:FireAllClients()

for _, player in Players:GetPlayers() do
	GameService:Add(player)
end

task.wait(7)
]]

local Normal = require(ServerStorage.Story.Normal)
Normal()

--[[
local Night = require(ServerStorage.Classes.Night).new(1, {
	SpawnType = "Block",
	Amount = 15
})
Night:Start()

]]

