local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local id = 1142073780

script.Parent.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player then return end
	MarketplaceService:PromptGamePassPurchase(player, id)
end)