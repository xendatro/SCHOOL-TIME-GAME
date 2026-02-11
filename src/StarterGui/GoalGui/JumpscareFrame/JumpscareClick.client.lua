for _, v in script.Parent:GetChildren() do
	if v:IsA("GuiButton") then
		v.MouseButton1Click:Connect(function()
			game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer, 3266604586)
		end)
	end
end