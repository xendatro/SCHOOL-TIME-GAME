local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Viewports = ReplicatedStorage.Viewports
local GoalFolder = ReplicatedStorage.Communication.Goal


local Main = script.Parent:WaitForChild("Main")
local JumpscareFrame = script.Parent:WaitForChild("JumpscareFrame")
local GoalAmount = Main:WaitForChild("GoalAmount")
local GoalType = Main:WaitForChild("GoalType")

GoalFolder.Update.OnClientEvent:Connect(function(data)
	local viewportFrame = Main:FindFirstChildOfClass("ViewportFrame")
	if viewportFrame then 
		viewportFrame:Destroy()
	end
	local clone = Viewports[data.GoalType]:Clone()
	clone.Parent = Main
	if data.GoalType == "WoodPlank" then
		data.GoalType = "Wood Plank"
	end
	GoalType.Text = data.GoalType
	GoalAmount.Text = `{data.GoalCurrentAmount}/{data.GoalAmount}`
end)

GoalFolder.Toggle.OnClientEvent:Connect(function(on)
	if on then
		Main.Visible = true
		JumpscareFrame.Visible = true
	else
		Main.Visible = false
		JumpscareFrame.Visible = false
	end
end)