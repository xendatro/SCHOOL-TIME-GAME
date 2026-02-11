local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AudioService = require(ReplicatedStorage.Services.AudioService)

local xenterface = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated)

local Objective = xenterface:Create("Objective")
local main = Objective:Find("Main")
local title = Objective:Find("Title")
local description = Objective:Find("Description")

local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local closeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local openTween = TweenService:Create(
	main,
	openInfo,
	{
		Position = UDim2.fromScale(0.01, 0.5)
	}
)
local closeTween = TweenService:Create(
	main,
	closeInfo,
	{
		Position = UDim2.fromScale(-0.3, 0.5)
	}
)

local titleInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
local descriptionInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)

local ObjectiveService = {}

function ObjectiveService:Toggle(on: boolean)
	if on then
		openTween:Play()
	else
		closeTween:Play()
	end
end

function ObjectiveService:Update(t: string, d: string)
	title.MaxVisibleGraphemes = 0
	description.MaxVisibleGraphemes = 0
	title.Text = t
	description.Text = d
	local titleTween = TweenService:Create(
		title,
		titleInfo,
		{
			MaxVisibleGraphemes = t:len()
		}
	)
	titleTween:Play()
	local notif = AudioService:Add("Notification", "SFX", false, "SFX_Notification")
	titleTween.Completed:Wait()
	local descriptionTween = TweenService:Create(
		description,
		descriptionInfo,
		{
			MaxVisibleGraphemes = d:len()
		}
	)
	descriptionTween:Play()
end

return ObjectiveService