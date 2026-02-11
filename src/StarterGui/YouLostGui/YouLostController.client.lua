local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage.Communication.End.End.OnClientEvent:Connect(function()
	script.Parent.Main.Visible = true
	print("HELLOOOOOOOOOOOOO")
	game:GetService("TweenService"):Create(
		script.parent.Main,
		TweenInfo.new(2),
		{
			Position = UDim2.fromScale(0, 0)
		}
	):Play()
end)