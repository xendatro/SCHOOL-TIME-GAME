local TweenService = game:GetService("TweenService")

TweenService:Create(
	script.Parent,
	TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, true),
	{
		Position = script.Parent.Position + UDim2.fromOffset(20, 0)
	}
):Play()