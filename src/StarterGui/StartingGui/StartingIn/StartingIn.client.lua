local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage.Communication.StartingIn.Update.OnClientEvent:Connect(function(startingIn)
	print(startingIn)
	script.Parent.Text = `Starting in: {startingIn}`
end)

ReplicatedStorage.Communication.StartingIn.Toggle.OnClientEvent:Connect(function(on)
	if on then
		script.Parent.Visible = true
	else
		script.Parent.Visible = false
	end
end)