local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneService = require(ReplicatedStorage.Services.CutsceneService)
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local AudioService = require(ReplicatedStorage.Services.AudioService)
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

return function()
	local Cutscene6 = CutsceneService:Create("Cutscene6")
	task.wait(1)
	AudioService:Add("End", "Ambience", false, "End")
	Cutscene6:Play()
	task.spawn(function()
		DialogueService:Show()
		DialogueService:Speak("Mr. Jenkins", "I can't believe it... we let them escape!")
		task.wait(6)
		DialogueService:Speak("Mrs. Klock", "Lebron James")
		task.wait(2)
		DialogueService:Speak("Mr. Jenkins", "What?")
		task.wait(2)
		DialogueService:Speak("Mrs. Klock", "Nothing. It'll be fine. I can make a call to admin, and they'll get things sorted out.")
		task.wait(6)
		DialogueService:Speak("Mr. Jenkins", "You mean... the superintendent?")
		task.wait(4)
		DialogueService:Speak("Mrs. Klock", "Yes, the superintendent.")
		task.wait(6)
		DialogueService:Speak("Mrs. Klock", "Don't worry. We will catch them.")
		task.wait(2)
		CurtainService:Show()
	end)
	CurtainService:Hide()

	Cutscene6:Play()
	Cutscene6.Ended:Wait()
	Cutscene6:Destroy()
	Player.PlayerGui.EndSceneGui.Main.Visible = true
	game:GetService("TweenService"):Create(
		Player.PlayerGui.EndSceneGui.Main,
		TweenInfo.new(2),
		{
			GroupTransparency = 0
		}
	):Play()
	task.wait(0.5)

	DialogueService:Hide()
end