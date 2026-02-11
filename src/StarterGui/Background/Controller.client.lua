local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local xenterface = require(ReplicatedStorage.Frameworks.xenterface.xenterface)

local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back)
local closeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local backgroundInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)

local background = script.Parent:WaitForChild("Background")

xenterface:CreateFunction("Menu", function(fo)
	print(fo)
	if #fo.SelectedPages > 0 then
		background.Visible = true
		TweenService:Create(background, backgroundInfo, {
			BackgroundTransparency = 0.4
		}):Play()
	else
		task.spawn(function()
			local tween = TweenService:Create(background, backgroundInfo, {
				BackgroundTransparency = 1
			})
			tween:Play()
			tween.Completed:Wait()

			background.Visible = false
		end)
	end
	for _, page in fo.SelectedPages do
		TweenService:Create(page, openInfo, {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	end
	
	for _, page in fo.UnselectedPages do
		TweenService:Create(page, openInfo, {
			Position = UDim2.fromScale(0.5, 2)
		}):Play()
	end
end)
