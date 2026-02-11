local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)

local Players = game:GetService("Players")

function getRandomSpeaker()
	return Players:GetChildren()[#Players:GetChildren()].Name
end

return function()
	CurtainService:ShowMessage("Three hours later...")
	task.wait(1)
	CurtainService:Hide()
	task.wait(1)
	CurtainService:ResetMessage()
	task.wait(1)
	DialogueService:Show()
	DialogueService:Speak(getRandomSpeaker(), "Yo, it's been like 3 hours. She hasn't come back. What do you guys think happened to her?")
	task.wait(6)
	DialogueService:Speak(getRandomSpeaker(), "Who cares? Let's just leave. Nobody's stopping us. Let's go y'all.")
	task.wait(6)
	DialogueService:Hide()
	ObjectiveService:Toggle(true)
	ObjectiveService:Update("Exit the School", "Go to the exit and escape!")
end