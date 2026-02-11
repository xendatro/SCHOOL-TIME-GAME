local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Gui = script.Parent
local Background = Gui:WaitForChild("Background")

local Update = ReplicatedStorage.Communication.XP.Update

local openInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local closeInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local openTween = TweenService:Create(Background, openInfo, {
	GroupTransparency = 0
})

local closeTween = TweenService:Create(Background, closeInfo, {
	GroupTransparency = 1
})

Update.OnClientEvent:Connect(function(updateData: {
	OldAmount: number?,
	NewAmount: number,
	Reason: string?,
	Show: boolean
	})
	if updateData.Show then
		Background.Visible = true
		openTween:Play()
		task.wait(3)
		closeTween:Play()
		closeTween.Completed:Wait()
		Background.Visible = false
	end
end)