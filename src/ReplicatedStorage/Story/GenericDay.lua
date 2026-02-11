local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)

local Players = game:GetService("Players")

function getRandomSpeaker()
	return Players:GetChildren()[#Players:GetChildren()].Name
end

return function()

end