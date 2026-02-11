local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ObjectiveService = {}

function ObjectiveService:Update(title: string, description: string)
	ReplicatedStorage.Communication.Objective.Update:FireAllClients(title, description)
end

function ObjectiveService:Toggle(on: boolean)
	ReplicatedStorage.Communication.Objective.Toggle:FireAllClients(on)
end

return ObjectiveService