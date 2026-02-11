local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneService = require(ReplicatedStorage.Services.CutsceneService)
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ShakeService = require(ReplicatedStorage.Services.ShakeService)
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)
local AudioService = require(ReplicatedStorage.Services.AudioService)


local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local camera = workspace.CurrentCamera

return function()
	task.wait(1)
	ObjectiveService:Toggle(false)
	--change this in the future
	local character = Players.LocalPlayer.Character
	character.Archivable = true
	local clone = character:Clone()
	clone.Parent = workspace
	clone.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	camera.CameraSubject = clone.Humanoid
	clone:PivotTo(CFrame.new(-201.601, 13.617, 39.96))
	CurtainService:Hide()
	local walkTrack = clone.Humanoid.Animator:LoadAnimation(script.WalkAnim)
	walkTrack:Play()
	clone.Humanoid:MoveTo(Vector3.new(-218.189, 13.617, 39.96))
	local track = clone.Humanoid.Animator:LoadAnimation(script.Unlock)
	clone.Humanoid.MoveToFinished:Wait()
	walkTrack:Stop()
	track:Play()
	task.wait(1.6)
	AudioService:Add("Boom", "SFX", false, "Boom")
	task.wait(0.1)
	AudioService:Add("Music", "Ambience", false, "Cutscene1.5Music")
	ShakeService:Create({
		ShakeType = "Once",
		Preset = "Scare",
		ID = "Quick"
	})
	task.wait(0.5)
	camera.CameraType = Enum.CameraType.Scriptable
	local tween1 = TweenService:Create(
		camera,
		TweenInfo.new(1, Enum.EasingStyle.Back),
		{
			CFrame = CFrame.new(camera.CFrame.Position, Vector3.new(-182.855, 25.2, 39.652))
		}
	)
	tween1:Play()
	tween1.Completed:Wait()
	local tween2 = TweenService:Create(
		camera,
		TweenInfo.new(4, Enum.EasingStyle.Quad),
		{
			CFrame = CFrame.new(Vector3.new(-188.45, 25.2, 39.652), Vector3.new(-182.855, 25.2, 39.652))
		}
	)
	tween2:Play()
	task.wait(3)
	local videoFrame: VideoFrame = PlayerGui.TVGui.CanvasGroup.VideoFrame
	videoFrame.Visible = true
	videoFrame:Play()
	task.delay(1, function()
		DialogueService:Show()
		DialogueService:Speak("Mrs. Klock", "Where do you think you're going?")
	end)

	task.delay(4, function()
		DialogueService:Speak("Mrs. Klock", "I told you to hang tight until I come back!")
	end)
	
	task.delay(7, function()
		DialogueService:Speak("Mrs. Klock", "I'm going to catch all of you! Every single last one of you!")
	end)
	
	task.delay(11, function()
		DialogueService:Speak("Mrs. Klock", "You guys are dead. DEAD! DEAD! DEAD!")
	end)
	videoFrame.Ended:Wait()
	DialogueService:Hide()
	CurtainService:Show()
	task.wait(1)
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = character.Humanoid
	clone:Destroy()
	CurtainService:Hide()
end