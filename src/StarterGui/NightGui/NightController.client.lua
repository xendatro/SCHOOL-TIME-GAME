local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local AudioService = require(ReplicatedStorage.Services.AudioService)

local showMessages = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("Night"):WaitForChild("ShowMessages")

local main = script.Parent.Main

local inInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back)

local tween = TweenService:Create(
	main.Bar.UIScale,
	TweenInfo.new(0.5, Enum.EasingStyle.Back),
	{
		Scale = 1
	}
)

local tweens = {}

for i = 1, 4 do
	local instance = main["Statement" .. tostring(i)]
	table.insert(tweens, TweenService:Create(instance, inInfo, {
		Position = UDim2.fromScale(0.5, instance.Position.Y.Scale)
	}))
end

local tween2 = TweenService:Create(
	main,
	TweenInfo.new(0.5, Enum.EasingStyle.Linear),
	{
		Position = UDim2.fromScale(1, 0)
	}
)

showMessages.OnClientEvent:Connect(function(nightMessages)
	task.wait(2)
	main.Night.Text = nightMessages[1]
	main.Statement1.Text = nightMessages[2]
	main.Statement2.Text = nightMessages[3]
	main.Statement3.Text = nightMessages[4]
	main.Statement4.Text = nightMessages[5]
	tween:Play()
	main.Visible = true
	AudioService:Add("NightNotif", "SFX", false, "NightNotif")
	task.wait(2)
	for i, tween in tweens do
		tween:Play()
		if i == #tweens then
			AudioService:Add("NormalNotif", "SFX", false, "LastNotif")
		else
			AudioService:Add("NormalNotif", "SFX", false, "NormalNotif")
		end
		task.wait(2)
	end
	tween2:Play()
	tween2.Completed:Wait()
	main.Visible = false
	main.Position = UDim2.fromScale(0, 0)
	main.Statement1.Position = UDim2.fromScale(-0.5, main.Statement1.Position.Y.Scale)
	main.Statement2.Position = UDim2.fromScale(-0.5, main.Statement2.Position.Y.Scale)
	main.Statement3.Position = UDim2.fromScale(-0.5, main.Statement3.Position.Y.Scale)
	main.Statement4.Position = UDim2.fromScale(-0.5, main.Statement4.Position.Y.Scale)
end)

