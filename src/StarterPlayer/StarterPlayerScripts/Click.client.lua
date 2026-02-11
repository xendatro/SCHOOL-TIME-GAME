local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClickSound = script:WaitForChild("Button Click"):Clone()
ClickSound.Parent = workspace

local function apply(button: GuiButton)
	button.MouseButton1Click:Connect(function()
		ClickSound:Play()
	end)
end

for _, button in CollectionService:GetTagged("Click") do
	apply(button)
end

CollectionService:GetInstanceAddedSignal("Click"):Connect(function(button)
	apply(button)
end)