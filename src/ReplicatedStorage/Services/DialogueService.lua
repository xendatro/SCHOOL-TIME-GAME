local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Dialogue = PlayerGui:WaitForChild("Dialogue")
local Main = Dialogue:WaitForChild("Main")

local info = TweenInfo.new(1, Enum.EasingStyle.Back)

local DialogueService = {}

function DialogueService:Show()
	Main.Position = UDim2.fromScale(0, 1)
	Main.Title.LeftBar.Size = UDim2.fromScale(0, 0.1)
	Main.Title.RightBar.Size = UDim2.fromScale(0, 0.1)
	TweenService:Create(
		Main.Title.LeftBar,
		info,
		{
			Size = UDim2.fromScale(0.32, 0.1)
		}
	):Play()
	TweenService:Create(
		Main.Title.RightBar,
		info,
		{
			Size = UDim2.fromScale(0.32, 0.1)
		}
	):Play()
	Main.Visible = true
end

function DialogueService:Hide()
	local tween = TweenService:Create(
		Main,
		info,
		{
			Position = UDim2.fromScale(0, 1.4)
		}
	)
	tween:Play()
	tween.Completed:Wait()
	Main.Visible = false
end

function DialogueService:Speak(speaker: string, message: string, noTick: boolean?)
	task.spawn(function()
		Main.Title.Speaker.Text = speaker
		Main.Message.Text = message
		Main.Message.MaxVisibleGraphemes = 0
		for i = 1, message:len() do
			Main.Message.MaxVisibleGraphemes = i
			if not noTick then
				AudioService:Add(tostring(i), "SFX", false, "Type")				
			end
			task.wait(0.05)
		end		
	end)
end

--[[
{
	{
		Speaker: string,
		Message: string,
		Duration: number
	}
}
]]



return DialogueService
