local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurtainEvents = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("Curtain")

local CurtainService = {}

local function sendToPlayers(players, eventName, ...)
	for _, player in ipairs(players) do
		local event = CurtainEvents:FindFirstChild(eventName)
		if event then
			event:FireClient(player, ...)
		end
	end
end

function CurtainService:Show(players)
	sendToPlayers(players, "Show")
end

function CurtainService:Hide(players)
	sendToPlayers(players, "Hide")
end

function CurtainService:ShowMessage(players, message)
	sendToPlayers(players, "ShowMessage", message)
end

function CurtainService:ResetMessage(players)
	sendToPlayers(players, "ResetMessage")
end

return CurtainService
