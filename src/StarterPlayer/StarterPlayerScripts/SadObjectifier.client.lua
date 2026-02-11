--[[
It's so sad that i have to make this script. I wish i had an IQ above goldfish

Sometimes in life you just have to stop what you're doing and say
"wow what an idiot i am, why did i do this?"
and the answer to that question is "because i am an idiot"

Doing this really purifies the soul and the mind. I am a better person now. 

- Ethan
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local Antagonist = require(ReplicatedStorage.Classes.Antagonist)

CollectionService:GetInstanceAddedSignal("Antagonist"):Connect(function(antagonist)
	if not antagonist:IsDescendantOf(workspace) then return end
	Antagonist.new(antagonist)
end)

for _, antagonist in CollectionService:GetTagged("Antagonist") do
	if not antagonist:IsDescendantOf(workspace) then continue end
	Antagonist.new(antagonist)
end

local killed = false

local track

ReplicatedStorage.Communication.Antagonist.Kill.OnClientEvent:Connect(function(kill, prompt)
	if kill then
		if killed then return end
		killed = true
		if prompt then
			prompt:Destroy()
		end
		local character = Player.Character
		if not character then return end
		track = character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Props.Animations.Crawl)
		character.Humanoid.WalkSpeed = 6
		track.Priority = Enum.AnimationPriority.Action4
		track:Play()
		RunService:BindToRenderStep(Player.Name, 1, function()
			if Controls.inputMoveVector.Magnitude == 0 then
				track:AdjustSpeed(0)
			else
				track:AdjustSpeed(1)
			end
		end)
		
		Player.PlayerGui.DownGui.Down.Visible = true
		--character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	else
		killed = false
		if track then
			track:Stop()
			track = nil
		end
		RunService:UnbindFromRenderStep(Player.Name)
		local character = Player.Character
		if not character then return end
		character.Humanoid.WalkSpeed = Player:GetAttribute("WalkSpeed")
		
		Player.PlayerGui.DownGui.Down.Visible = false
	end
end)