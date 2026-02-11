local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local Tag = "Purchase"

local function apply(button: GuiButton)
	button.MouseButton1Click:Connect(function()
		local typeOf = button:GetAttribute("Type")
		local id = button:GetAttribute("Id")
		if typeOf == "Product" then
			MarketplaceService:PromptProductPurchase(Player, id)
		elseif typeOf == "Gamepass" then
			MarketplaceService:PromptGamePassPurchase(Player, id)
		elseif typeOf == "Subscription" then
			MarketplaceService:PromptSubscriptionPurchase(Player, id)
		end
	end)
end

CollectionService:GetInstanceAddedSignal(Tag):Connect(apply)

for _, v in CollectionService:GetTagged(Tag) do
	apply(v)
end

local reviveFunction = Instance.new("BindableFunction")

reviveFunction.Parent = workspace

local set: Player = nil

reviveFunction.OnInvoke = function(message: string)
	local playerName = string.sub(message, 8, string.len(message))
	local player = Players:FindFirstChild(playerName)
	ReplicatedStorage.Communication.Revive.Set:FireServer(player)
	MarketplaceService:PromptProductPurchase(Player, 3260078201)
end

ReplicatedStorage.Communication.Revive.Prompt.OnClientEvent:Connect(function(playerToRevive)
	--[[StarterGui:SetCore("SendNotification", {
		Title = `Revive {playerToRevive.Name}`,
		Text = `{playerToRevive.Name} has died!`,
		Duration = 15,
		Button1 = `Revive {playerToRevive.Name}`,
		Callback = reviveFunction
	})]]
end)