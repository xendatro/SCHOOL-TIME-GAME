local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local offset = -3

function apply(hover)
	local position = hover.Position

	hover.MouseEnter:Connect(function()
		TweenService:Create(
			hover,
			TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{
				Position = position + UDim2.fromOffset(0, offset)
			}
		):Play()
	end)

	hover.MouseLeave:Connect(function()
		TweenService:Create(
			hover,
			TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
			{
				Position = position
			}
		):Play()
	end)
end

CollectionService:GetInstanceAddedSignal("Hover"):Connect(function(hover)
	apply(hover)
end)

for _, hover in CollectionService:GetTagged("Hover") do
	apply(hover)
end
