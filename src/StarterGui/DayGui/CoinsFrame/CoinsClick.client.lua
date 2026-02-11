local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _, v in script.Parent:GetChildren() do
	if v:IsA("GuiButton") then
		v.MouseButton1Click:Connect(function()
			game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer, 3260358801)
		end)
	end
end

ReplicatedStorage.Communication.Coins.Toggle.OnClientEvent:Connect(function(on: boolean)
	if on then
		TweenService:Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Back), {
			Position = UDim2.fromScale(1, 0.5)
		}):Play()
	else
		TweenService:Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Linear), {
			Position = UDim2.fromScale(1.1, 0.5)
		}):Play()
	end
end)