local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

game.TextChatService.Rejoin.Triggered:Connect(function(origin)
	print("REJOINN???")
	local player = Players[origin.Name]
	TeleportService:TeleportAsync(71861453126203, {player})
end)

game:GetService("ReplicatedStorage").Communication.Lobby.Activate.OnServerEvent:Connect(function(player, part)
	player.ReplicationFocus = part
end)

game:GetService("ReplicatedStorage").Communication.Tools.Drop.OnServerEvent:Connect(function(player, tool)
	if player.Character == nil or not tool:IsDescendantOf(player.Character) then return end
	tool.Parent = workspace
end)