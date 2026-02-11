local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneService = require(ReplicatedStorage.Services.CutsceneService)
local DialogueService = require(ReplicatedStorage.Services.DialogueService)
local CurtainService = require(ReplicatedStorage.Services.CurtainService)
local AudioService = require(ReplicatedStorage.Services.AudioService)

local cloned = {}

local function playEffect(part: BasePart)
	AudioService:Add("MetalHit", "SFX", false, "MetalHit")
	for _, v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") then
			local amount = v:GetAttribute("EmitCount")
			v:Emit(amount)
		end
	end
end

local function cloneEffectPartIn(name)
	local part = script[name]:Clone()
	table.insert(cloned, part)
	part.Parent = workspace
	return part
end

local function cutOffLights(name)
	AudioService:Add("LightsOff", "SFX", false, "LightsOff")
	local lights = workspace.Lights:FindFirstChild(name)
	game.Lighting.Atmosphere.Density = 1
	for _, v in lights:GetChildren() do
		v.BrickColor = BrickColor.new("Really black")
		v.SpotLight.Enabled = false
	end
end

return function()
	local Cutscene5 = CutsceneService:Create("Cutscene5")
	game.Lighting.ClockTime = 2
	DialogueService:Show()
	DialogueService:Speak("Mr. Jenkins", "What are you doing with that shovel?")
	task.wait(1)
	AudioService:Add("Cutscene5Music", "Ambience", false, "Cutscene5Music")
	Cutscene5:Play()
	task.delay(3, function()
		DialogueService:Speak("Mrs. Klock", "Cutting off the power. Gonna shatter this thing to pieces.")
	end)
	CurtainService:Hide()
	local strike = cloneEffectPartIn("Strike")
	
	local effects = Cutscene5:GetTrackByRigName("EffectsDummy")
	effects:GetMarkerReachedSignal("Strike"):Wait()
	local smoke = cloneEffectPartIn("Smoke")
	playEffect(strike)
	effects:GetMarkerReachedSignal("Strike"):Wait()
	playEffect(strike)
	DialogueService:Speak("Mr. Jenkins", "?!?! Stop!! What is the point of this??")
	local electricity = cloneEffectPartIn("Electricity")
	AudioService:Add("ElectricLoud", "SFX", true, "ElectricLoud")
	effects:GetMarkerReachedSignal("Strike"):Wait()
	playEffect(strike)
	effects:GetMarkerReachedSignal("Strike"):Wait()
	playEffect(strike)
	DialogueService:Speak("Mrs. Klock", "The students need to be taught a lesson.")
	effects:GetMarkerReachedSignal("Strike"):Wait()
	playEffect(strike)
	effects:GetMarkerReachedSignal("LowRumble"):Wait()
	effects:GetMarkerReachedSignal("HighRumble"):Wait()
	AudioService:Add("Explosion", "SFX", false, "Explosion")
	task.spawn(function()
		AudioService:Remove("ElectricLoud")
		AudioService:Remove("Cutscene5Music", true, 3)
	end)
	local explosion = cloneEffectPartIn("Explosion")
	DialogueService:Speak("Mrs. Klock", "AHHHHHHH")
	effects:GetMarkerReachedSignal("FinishExplode"):Wait()
	Cutscene5:Pause()
	DialogueService:Hide()
	CurtainService:Show()
	task.wait(1)
	explosion:Destroy()
	local light = cloneEffectPartIn("Light")
	workspace.CurrentCamera.CFrame = CFrame.new(-152.11171, 19.8122597, 79.8420868, 0.919725537, 0.000896252983, -0.392561078, 1.16415322e-10, 0.999997437, 0.00228308607, 0.392562121, -0.0020998125, 0.919723153)
	CurtainService:Hide()
	task.delay(1.5, function()
		cutOffLights("Group1Lights")
	end)
	task.wait(3)
	game.Lighting.Atmosphere.Density = 0.7
	workspace.CurrentCamera.CFrame = CFrame.new(-164.119247, 19.4915504, 119.551422, -0.872625828, 0.0264908057, 0.487670541, -1.86264537e-09, 0.998527944, -0.0542411432, -0.488389552, -0.0473322235, -0.871341109)
	task.delay(1.5, function()
		cutOffLights("Group2Lights")
	end)
	task.wait(3)
	game.Lighting.Atmosphere.Density = 0.7
	workspace.CurrentCamera.CFrame = CFrame.new(-152.253754, 20.4127426, 127.575523, -0.946556568, -0.0060990355, -0.322480261, -4.65661287e-10, 0.999821305, -0.0189095121, 0.322537929, -0.0178989228, -0.946387351)
	task.delay(1.5, function()
		cutOffLights("Group3Lights")
	end)
	task.wait(3)
	Cutscene5:Resume()
	local function enableElectro(rigName)
		local rig = Cutscene5:GetRigByRigName(rigName)
		for _, v in rig.ElectroPart:GetChildren() do
			if v:IsA("ParticleEmitter") then
				v.Enabled = true
			end
		end
	end
	enableElectro("RealCutscene5principal")
	enableElectro("RealCutscene5teacher")
	AudioService:Add("ElectricSoft", "SFX", true, "ElectricSoft")
	DialogueService:Show()
	DialogueService:Speak("Mrs. Jenkins", "...")
	task.delay(4, function()
		DialogueService:Hide()
	end)
	task.delay(4.5, function()
		CurtainService:Show()
	end)
	Cutscene5.Ended:Wait()
	Cutscene5:Destroy()
	task.wait(1)
	CurtainService:Hide()
	light:Destroy()
	AudioService:Remove("ElectricSoft", true, 3)
	
end