local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tools = ReplicatedStorage.Tools


local BackpackService = {}

BackpackService.Maxes = {}
BackpackService.Quantities = {
	
}

function BackpackService:Get(player: Player, toolName: string)
	local backpack = player.Backpack
	local character = player.Character
	if not character then 
		warn("No character exists.")
		return
	end
	local tool = backpack:FindFirstChild(toolName)
	if tool then return tool end
	tool = character:FindFirstChild(toolName)
	if tool and tool:IsA("Tool") then return tool end
end

function BackpackService:GetQuantity(player)
	if BackpackService.Quantities[player] == nil then
		BackpackService.Quantities[player] = 0
	end
	return BackpackService.Quantities[player]
end

function BackpackService:IncrementQuantity(player, n: number)
	BackpackService.Quantities[player] += n
	print(BackpackService.Quantities[player])
end

function BackpackService:DecrementQuantity(player, n: number)
	BackpackService.Quantities[player] -= n
	print(BackpackService.Quantities[player])
end

function BackpackService:SetQuantity(player, n)
	BackpackService.Quantities[player] = n
end

local function getMax(player)
	return BackpackService.Maxes[player] or 10
end

function BackpackService:Add(player: Player, toolName: string, n: number)
	local quantity = BackpackService:GetQuantity(player)
	print(quantity)
	local max = getMax(player)
	if quantity == max then 
		--error
		print("ERROR")
		return false
	end
	if quantity + n > max then
		n = max - quantity
	end
	local tool = BackpackService:Get(player, toolName)
	if not tool then
		tool = Tools[toolName]:Clone()
		tool.Parent = player.Backpack
	end
	tool:SetAttribute("quantity", tool:GetAttribute("quantity") + n)
	BackpackService:IncrementQuantity(player, n)
	return true
end

function BackpackService:Remove(player: Player, toolName: string, n: number)
	BackpackService:DecrementQuantity(player, n)
	local tool = BackpackService:Get(player, toolName)
	if tool == nil then return end
	tool:SetAttribute("quantity", tool:GetAttribute("quantity") - n)
	if tool:GetAttribute("quantity") <= 0 then
		tool:Destroy()
	end
end

function BackpackService:RemoveAll(player: Player, toolName: string): number
	local tool = BackpackService:Get(player, toolName)
	if tool == nil then return 0 end
	local amount = tool:GetAttribute("quantity")
	BackpackService:Remove(player, toolName, amount)
	return amount
end

return BackpackService
