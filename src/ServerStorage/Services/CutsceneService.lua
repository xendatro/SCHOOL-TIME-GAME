local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Signal = require(ReplicatedStorage.Classes.Signal)

local CutsceneEvents = ReplicatedStorage.Communication.Cutscenes
local GameService = require(ServerStorage.Services.GameService)

local CutsceneService = {}

function CutsceneService:Play(cutsceneName: string)
	CutsceneEvents.Play:FireAllClients(cutsceneName)
end

function CutsceneService:Stop()
	CutsceneEvents.Stop:FireAllClients()
end

function CutsceneService:WaitForCutsceneToFinish(cutsceneName: string)
	local signal = Signal.new()
	local connection = ReplicatedStorage.Communication.Cutscenes.Finished.OnServerEvent:Connect(function(_, incomingCutsceneName)
		if cutsceneName == incomingCutsceneName then
			signal:Fire()
		end
	end)
	signal:Wait()
	connection:Disconnect()
end

return CutsceneService
