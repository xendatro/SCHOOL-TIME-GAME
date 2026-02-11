local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer


ContextActionService:BindAction("Drop", function(actionName, inputState, inputObject)
	if inputState ~= Enum.UserInputState.Begin then return end
	local character = Player.Character
	if character == nil then return end
	local tool = character:FindFirstChildOfClass("Tool")
	if tool == nil then return end
	ReplicatedStorage.Communication.Tools.Drop:FireServer(tool)
end, true, Enum.KeyCode.F12, Enum.KeyCode.ButtonB)

ContextActionService:SetTitle("Drop", "Drop Item")
ContextActionService:SetPosition("Drop", UDim2.fromScale(0.3, 0.3))

local button = ContextActionService:GetButton("Drop")

if button then
	button.Size = UDim2.fromScale(0.4, 0.4)
	local constraint = Instance.new("UIAspectRatioConstraint")
	constraint.Parent = button
	constraint.AspectRatio = 1
end