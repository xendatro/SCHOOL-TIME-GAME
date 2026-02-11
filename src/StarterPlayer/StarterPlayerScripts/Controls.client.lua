local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerScripts = player:WaitForChild("PlayerScripts")

local CurtainService = require(ReplicatedStorage.Services.CurtainService)

-- Get the ControlModule
local controlModule = require(PlayerScripts:WaitForChild("PlayerModule")):GetControls()

local SetControlsRemote = ReplicatedStorage:WaitForChild("Communication")
	:WaitForChild("Character"):WaitForChild("SetControls")

SetControlsRemote.OnClientEvent:Connect(function(enabled: boolean)
	if enabled then
		controlModule:Enable()
	else
		controlModule:Disable()
	end
end)