local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local ObjectiveService = require(ReplicatedStorage.Services.ObjectiveService)
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local Players = game:GetService("Players")

local Camera = workspace.CurrentCamera

function getRandomSpeaker()
	return Players:GetChildren()[#Players:GetChildren()].Name
end

return function()
	CurtainService:ShowMessage("Placing ion batteries...")
	task.wait(1)
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.CFrame = CFrame.new(-59.3168068, 18.8808193, 95.4380112, 0.377548039, 0.106589407, -0.919834912, 3.7252903e-09, 0.993353009, 0.115108587, 0.925990045, -0.0434590243, 0.375038475)
	TweenService:Create(
		Camera,
		TweenInfo.new(8, Enum.EasingStyle.Linear),
		{
			CFrame = CFrame.new(-47.4422379, 18.9555206, 103.964371, 0.994912684, -0.0153592899, 0.0995641202, 9.31322575e-10, 0.988309562, 0.152461857, -0.100741848, -0.151686236, 0.983281553)
		}
	):Play()
	local clone = ReplicatedStorage.Props.General["Cutscene5.5"]:Clone()
	clone.Parent = workspace
	CurtainService:Hide()
	task.wait(1)
	CurtainService:ResetMessage()
	task.wait(1)
	DialogueService:Show()
	DialogueService:Speak(getRandomSpeaker(), "Nice! That's all of the ion batteries placed.")
	task.wait(6)
	DialogueService:Hide()
	CurtainService:Show()
	local character = Players.LocalPlayer.Character
	character.Archivable = true
	local clone = character:Clone()
	clone.Parent = workspace
	clone.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	clone:PivotTo(CFrame.new(-171.476364, 17.5295925, 40.1353531, 0.0652796254, -0.0899716765, 0.993802667, -4.65661343e-10, 0.995927095, 0.0901639834, -0.997867107, -0.00588587159, 0.0650137365))
	ReplicatedStorage.Communication.Lobby.Activate:FireServer(clone.PrimaryPart)
	task.wait(1)
	Camera.CFrame = CFrame.new(-194.782608, 21.1934662, 54.295105, 0.214421004, -0.185212106, 0.959020376, -3.72529074e-09, 0.981857181, 0.189622447, -0.976741433, -0.0406590402, 0.210530758)
	local tween2 = TweenService:Create(
		Camera,
		TweenInfo.new(8, Enum.EasingStyle.Linear),
		{
			CFrame = CFrame.new(-193.065491, 21.3658638, 29.2232513, -0.225938171, -0.206681982, 0.951963544, -0, 0.977233291, 0.212168291, -0.974141717, 0.0479369164, -0.220794261)
		}
	)
	CurtainService:Hide()
	tween2:Play()
	task.wait(3)
	for _, v in CollectionService:GetTagged("MainDoor") do
		v:Destroy()
	end
	DialogueService:Show()
	DialogueService:Speak(getRandomSpeaker(), "The main doors are open! Let's get out of here!")
	clone.Humanoid.WalkSpeed = 10
	local walkTrack = clone.Humanoid.Animator:LoadAnimation(script.WalkAnim)
	walkTrack:Play()
	clone.Humanoid:MoveTo(Vector3.new(-223.189, 13.617, 39.96))
	tween2.Completed:Wait()
	DialogueService:Hide()
	ReplicatedStorage.Communication.Lobby.Activate:FireServer(character.PrimaryPart)
	CurtainService:Show()
	task.wait(1)
end