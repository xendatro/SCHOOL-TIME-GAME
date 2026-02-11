local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")


script.Parent.MouseButton1Click:Connect(function()
	ReplicatedStorage.Communication.Revive.Set:FireServer(Players.LocalPlayer)
	MarketplaceService:PromptProductPurchase(Players.LocalPlayer, 3260078201)
end)