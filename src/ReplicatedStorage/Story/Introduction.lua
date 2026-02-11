local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneService = require(ReplicatedStorage.Services.CutsceneService)
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local AudioService = require(ReplicatedStorage.Services.AudioService)
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")
local description = humanoid:WaitForChild("HumanoidDescription")




function loadRandomPlayers()
	local characters = ReplicatedStorage.Friends:GetChildren()
	local desks = workspace.Desks:GetChildren()
	local toReturnCharacters = {}
	for _, desk in desks do
		task.spawn(function()
			local clone = characters[math.random(1, #characters)]:Clone()
			clone.Parent = workspace
			table.insert(toReturnCharacters, clone)
			task.wait(0.5)
			local weld = Instance.new("Weld", clone.PrimaryPart)
			weld.C0 = CFrame.new(0, -1, 0)
			weld.Part0 = clone.PrimaryPart
			weld.Part1 = desk.Seat
			local track = clone.Humanoid.Animator:LoadAnimation(script.Animation)
			track:Play()
			track:AdjustSpeed(0)
		end)
	end
	return toReturnCharacters
end

return function()
	local introduction = CutsceneService:Create("Introduction")
	local classroom = CutsceneService:Create("Classroom")
	local schoolBell = CutsceneService:Create("SchoolBell")
	local throw = CutsceneService:Create("IntroductionThrow")
	local humanoid: Humanoid = throw:GetRigByRigName("ThrowDummy").Humanoid
	humanoid:ApplyDescription(description)
	local characters = loadRandomPlayers()
	task.wait(1)
	task.spawn(function()
		task.wait(1) -- Ensure curtain covers the screen before playing
		CurtainService:Hide()		
	end)

	task.spawn(function()
		AudioService:Add("Introduction", "Ambience", false, "Introduction")
		AudioService:Add("IntroductionTalking", "Ambience", false, "IntroductionTalking")
		AudioService:Add("SchoolBell", "SFX", false, "SchoolBell")
		DialogueService:Show()
		DialogueService:Speak("Mrs. Klock", "Good afternoon class. Please take your seats, we have a lot to cover today.")
		task.wait(7)
		DialogueService:Speak("Mrs. Klock", "Settle down, settle down. We are very behind schedule.")
		task.wait(8)
		DialogueService:Speak("Mrs. Klock", "Now if you recall from last lecture, we were talking about the quadratic formula.")
		task.wait(11)
		DialogueService:Speak("Mrs. Klock", "Who can remind us what the quadratic formula is?")
		task.wait(9)
		DialogueService:Speak("Mrs. Klock", "Ok... no one. Wonderful. The quadratic formula is x = -b...")
		task.wait(3.6)
		AudioService:Add("Hit", "SFX", false, "Hit")
		task.wait(0.2)
		AudioService:Remove("Introduction", false)
		AudioService:Remove("IntroductionTalking", false)
		AudioService:Add("Erie", "Ambience", false, "Erie")
		DialogueService:Speak("Mrs. Klock", "AH-")
		task.wait(1)
		DialogueService:Speak("Mrs. Klock", "...")
		task.wait(3)
		DialogueService:Speak("Mrs. Klock", "Who... threw... that...")
		task.wait(5)
		DialogueService:Speak("Mrs. Klock", "I'm going to give you guys one opportunity to tell me who threw that.")
		task.wait(6)
		DialogueService:Speak("Mrs. Klock", "Fine. Detention. ALL of you. You are all staying after school.")
		task.wait(4)
		AudioService:Add("SchoolBell", "SFX", false, "SchoolBell")
		DialogueService:Speak("School Bell", "RRRRRINGGGGG", true)
		task.wait(2)
		DialogueService:Speak("Mrs. Klock", "Nope, you all have detention. You are NOT allowed to leave.")
		task.wait(5)
		DialogueService:Speak("Mrs. Klock", "I will be speaking to the principal. Please hang tight here until I come back.")
		task.wait(3)
		CurtainService:Show()
		task.wait(2)
		DialogueService:Hide()
	end)

	classroom:Play()
	classroom:GetTrackByRigName("EffectsDummy"):GetMarkerReachedSignal("Finished"):Wait()
	classroom:Pause()
	introduction:Play()
	local deskChalk = introduction:GetRigByRigName("EffectsDummy").Chalk
	local teacherChalk = introduction:GetRigByRigName("Teacher").Chalk
	deskChalk.Transparency = 0
	teacherChalk.Transparency = 1
	task.wait(1)
	local introductionMainTrack = introduction:GetTrackByRigName("Teacher")
	introductionMainTrack:GetMarkerReachedSignal("PickUpChalk"):Wait()
	deskChalk.Transparency = 1
	teacherChalk.Transparency = 0
	introductionMainTrack:GetMarkerReachedSignal("Throw"):Wait()
	introduction:Pause()
	throw:Play()
	local throwMainTrack = throw:GetTrackByRigName("ThrowDummy")
	throwMainTrack:GetMarkerReachedSignal("Finished"):Wait()
	throw:Pause()
	introduction:Resume()
	local cower = CutsceneService:Create("Cower")
	task.wait(1)
	throw:Destroy()
	cower:GetRigByRigName("ThrowDummy").Humanoid:ApplyDescription(description)
	introductionMainTrack:GetMarkerReachedSignal("Classroom"):Wait()
	introduction:Pause()
	teacherChalk.Transparency = 1
	cower:Play()
	cower:GetTrackByRigName("ThrowDummy"):GetMarkerReachedSignal("Finished"):Wait()
	cower:Pause()
	introduction:Resume()
	introduction:AdjustTimePosition(20.2)
	introductionMainTrack:GetMarkerReachedSignal("SchoolBell"):Wait()
	introduction:Pause()
	schoolBell:Play()
	schoolBell:GetTrackByRigName("EffectsDummy"):GetMarkerReachedSignal("Finished"):Wait()
	schoolBell:Pause()
	introduction:Resume()
	introductionMainTrack:GetMarkerReachedSignal("Finished"):Wait()
	introduction:Stop()

	introduction:Destroy()
	schoolBell:Destroy()
	cower:Destroy()
	classroom:Destroy()
	
	for _, character in characters do
		character:Destroy()
	end

	workspace.CurrentCamera.FieldOfView = 70
end
