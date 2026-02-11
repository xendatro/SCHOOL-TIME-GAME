local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShakeService = require(ReplicatedStorage.Services.ShakeService)
local TextChatService = game:GetService("TextChatService")

local dummy = ReplicatedStorage.Props.Other.JumpscarePrincipal:Clone()
dummy.Parent = workspace

local model = workspace:WaitForChild("JumpscareModel", 15)

local camera = workspace.CurrentCamera

local jumpscareSound = script.JumpscareSound:Clone()
jumpscareSound.Parent = workspace

local spotTrack = dummy:WaitForChild("Humanoid").Animator:LoadAnimation(dummy.Animations.Spot)

local function play(evilDoer)
	--if evilDoer ~= game.Players.LocalPlayer then
		jumpscareSound:Play()
		camera.CameraType = Enum.CameraType.Scriptable
		ShakeService:Create({
			ShakeType = "Once",
			Preset = "Jumpscare",
			ID = "Jumpscare"
		})
		spotTrack:Play()
		spotTrack.Priority = Enum.AnimationPriority.Action4
		spotTrack:AdjustSpeed(0.4)
		spotTrack.Looped = false
		camera.CFrame = model.JumpscarePart.CFrame
	--end
	TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(`[SYSTEM]: {evilDoer.Name} has jumpscared everybody!`)
	task.wait(2)
	camera.CameraType = Enum.CameraType.Custom
end

ReplicatedStorage.Communication.Jumpscare.Play.OnClientEvent:Connect(function(evilDoer)
	play(evilDoer)
end)
