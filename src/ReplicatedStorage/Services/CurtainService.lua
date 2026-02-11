local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurtainEvents = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("Curtain")

local CurtainService = {}

local function getCurtainFrame()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local curtainGui = playerGui:WaitForChild("CurtainGui")
	return curtainGui:WaitForChild("Main")
end

function CurtainService:Show()
	local frame = getCurtainFrame()
	if not frame then return end
	frame.Visible = true
	local tween = TweenService:Create(frame, TweenInfo.new(1), {GroupTransparency = 0})
	tween:Play()
end

function CurtainService:Hide()
	local frame = getCurtainFrame()
	if not frame then return end

	local tween = TweenService:Create(frame, TweenInfo.new(1), {GroupTransparency = 1})
	tween:Play()

	tween.Completed:Connect(function()
		frame.Visible = false
	end)
end

function CurtainService:ShowMessage(message)
	local frame = getCurtainFrame()
	if not frame then return end

	local textLabel = frame:FindFirstChild("TextLabel")
	if not textLabel then return end

	textLabel.Text = message
	textLabel.MaxVisibleGraphemes = 0

	for i = 1, #message do
		textLabel.MaxVisibleGraphemes = i
		task.wait(0.07)
	end
end

function CurtainService:ResetMessage()
	local frame = getCurtainFrame()
	if not frame then return end

	local textLabel = frame:FindFirstChild("TextLabel")
	if not textLabel then return end

	textLabel.MaxVisibleGraphemes = 0
end

-- Remote connections
CurtainEvents:WaitForChild("Show").OnClientEvent:Connect(function()
	CurtainService:Show()
end)

CurtainEvents:WaitForChild("Hide").OnClientEvent:Connect(function()
	CurtainService:Hide()
end)

CurtainEvents:WaitForChild("ShowMessage").OnClientEvent:Connect(function(message)
	CurtainService:ShowMessage(message)
end)

return CurtainService
