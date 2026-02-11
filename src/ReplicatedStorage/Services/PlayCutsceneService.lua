local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayCutsceneService = {}

local function playCutscene(cutsceneName: string)
	local cutsceneModule = ReplicatedStorage:WaitForChild("Story"):WaitForChild(cutsceneName)
	if cutsceneModule and cutsceneModule:IsA("ModuleScript") then
		local cutsceneFunction = require(cutsceneModule)
		if type(cutsceneFunction) == "function" then
			cutsceneFunction()
			ReplicatedStorage.Communication.Cutscenes.Finished:FireServer(cutsceneName)
		end
	end
end

local function stopCutscene()
	-- Function architecture for stopping a cutscene (implementation to be added later)
end

ReplicatedStorage.Communication.Cutscenes.Play.OnClientEvent:Connect(playCutscene)
ReplicatedStorage.Communication.Cutscenes.Stop.OnClientEvent:Connect(stopCutscene)

return PlayCutsceneService
