local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)

local Players = game:GetService("Players")

function getRandomSpeaker()
	return Players:GetChildren()[#Players:GetChildren()].Name
end

return function()
	DialogueService:Show()
	DialogueService:Speak(getRandomSpeaker(), "Phew, we've boarded ourselves in the art room. She can't get us in here.")
	task.wait(6)
	DialogueService:Speak(getRandomSpeaker(), "Let's just camp out here for the day and make preparations for the night.")
	task.wait(6)
	DialogueService:Hide()
end