local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Update = ReplicatedStorage.Communication.Gems.Update

Update.OnClientEvent:Connect(function(amount)
	script.Parent.Text = amount or 0
end)