local MarketplaceService = game:GetService("MarketplaceService")

script.Parent.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, 3285232563)
end)