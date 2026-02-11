local ReplicatedStorage = game:GetService("ReplicatedStorage")

local xenterface = require(ReplicatedStorage.Frameworks.xenterface.xenterface)

local Update = ReplicatedStorage.Communication.Coins.Update

Update.OnClientEvent:Connect(function(updateData: {
	OldAmount: number?,
	NewAmount: number,
	Reason: string?,
	Show: boolean
	})
	print(updateData)
	for _, coinLabel in xenterface:GetElementsByClass("CoinLabel") do
		print(coinLabel)
		coinLabel.Text = updateData.NewAmount or 0
	end
end)

--Initial
Update:FireServer()