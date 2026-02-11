local ServerStorage = game:GetService("ServerStorage")
local GameService = require(ServerStorage.Services.GameService)
local Players = game:GetService("Players")
local CharacterService = require(ServerStorage.Services.CharacterService)
local CutsceneService = require(ServerStorage.Services.CutsceneService)
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurtainService = require(ServerStorage.Services.CurtainService)
local AudioService = require(ReplicatedStorage.Services.AudioService)
local DataSaveService = require(ServerStorage.Services.DataSaveService)
local BadgeService = game:GetService("BadgeService")

local DataStoreService = game:GetService("DataStoreService")

local WinsStore = DataStoreService:GetOrderedDataStore("Wins")

local Night1 = require(ServerStorage.Story.Night1)
local Day1 = require(ServerStorage.Story.Day1)

local Night2 = require(ServerStorage.Story.Night2)
local Day2 = require(ServerStorage.Story.Day2)

local Night3 = require(ServerStorage.Story.Night3)
local Day3 = require(ServerStorage.Story.Day3)

local Night4 = require(ServerStorage.Story.Night4)
local Day4 = require(ServerStorage.Story.Day4)

local Night5 = require(ServerStorage.Story.Night5)
local Day5 = require(ServerStorage.Story.Day5)


local Signal = require(ReplicatedStorage.Classes.Signal)

local InitialBarrier = workspace.InitialBarrier

return function()
	CutsceneService:Play("Introduction")
	CutsceneService:WaitForCutsceneToFinish("Introduction")
	for _, desk in workspace.Desks:GetChildren() do
		desk.Seat:Destroy()
	end
	CharacterService:BatchMoveTo(GameService.Alive, "InitialClassroom")
	task.wait(2)
	AudioService:Add("Background", "Ambience", true, "Background")
	CharacterService:SetWalkSpeed(GameService.Alive, -1)
	CutsceneService:Play("ToLobby")
	CutsceneService:WaitForCutsceneToFinish("ToLobby")
	CurtainService:Hide(Players:GetPlayers())
	workspace.Important.ExitPart.BillboardGui.Enabled = true
	local waitForLobby = Signal.new()
	local connection = workspace.Locations.Lobby.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") then
			waitForLobby:Fire()
		end
	end)
	waitForLobby:Wait()
	connection:Disconnect()
	workspace.Important.ExitPart.BillboardGui.Enabled = false
	CurtainService:Show(Players:GetPlayers())
	task.wait(1)
	CharacterService:SetControls(GameService.Alive, false)
	AudioService:Remove("Background", true, 3)
	CharacterService:BatchMoveTo(GameService.Alive, "InitialClassroom")
	CutsceneService:Play("Cutscene1_5")
	CutsceneService:WaitForCutsceneToFinish("Cutscene1_5")
	CharacterService:BatchMoveTo(GameService.Alive, "Lobby")
	CharacterService:SetControls(GameService.Alive, true)
	CharacterService:SetWalkSpeed(GameService.Alive, -1)
	task.wait(1)
	CurtainService:Hide(Players:GetPlayers())
	InitialBarrier:Destroy()
	Night1()
	task.wait(2)
	Day1()
	
	CurtainService:Show(Players:GetPlayers())
	task.wait(1)
	CharacterService:BatchMoveTo(GameService.Alive, "Shop")
	task.wait(1)
	CutsceneService:Play("PhoneCall")
	CutsceneService:WaitForCutsceneToFinish("PhoneCall")
	task.wait(1)
	CurtainService:Hide(Players:GetPlayers())
	Night2()
	task.wait(2)
	Day2()
	CurtainService:Show(Players:GetPlayers())
	task.wait(1)
	CutsceneService:Play("Cutscene3")
	CutsceneService:WaitForCutsceneToFinish("Cutscene3")
	task.wait(1)
	CurtainService:Hide(Players:GetPlayers())
	Night3()
	task.wait(2)
	Day3()
	CurtainService:Show(Players:GetPlayers())
	task.wait(1)
	task.delay(1, function()
		CurtainService:Hide(Players:GetPlayers())
	end)
	CutsceneService:Play("Cutscene4")
	CutsceneService:WaitForCutsceneToFinish("Cutscene4")
	CurtainService:Hide(Players:GetPlayers())
	Night4()
	task.wait(2)
	Day4()
	CurtainService:Show(Players:GetPlayers())
	task.wait(1)
	CutsceneService:Play("Cutscene5")
	CutsceneService:WaitForCutsceneToFinish("Cutscene5")
	Night5()
	local success, err = pcall(function()
		for _, player in GameService.Alive do
			BadgeService:AwardBadge(player.UserId, 1939378758820766)
		end
	end)
	CutsceneService:Play("Cutscene5_5")
	CutsceneService:WaitForCutsceneToFinish("Cutscene5_5")
	task.wait(1)
	for _, player in GameService.Alive do
		local success, err = pcall(function()
			local data = DataSaveService:Get(player)
			if data then
				data.Wins += 1
			end
			local Wins = player.leaderstats.Wins
			Wins.Value = data.Wins
			
			WinsStore:UpdateAsync(player.UserId, function() return data.Wins end)
		end)
	end
	CutsceneService:Play("Cutscene6")
	CutsceneService:WaitForCutsceneToFinish("Cutscene6")
end