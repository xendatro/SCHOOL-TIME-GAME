local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

ContentProvider:PreloadAsync({
	script.Parent.CanvasGroup.Title,
	script.Parent.CanvasGroup.Loading
})


local Player = Players.LocalPlayer

local gui = script.Parent

local teleportData = TeleportService:GetLocalPlayerTeleportData()

local playerAddedConnection = nil


local info3 = TweenInfo.new(2, Enum.EasingStyle.Linear)

if teleportData then
	gui.Parent = Player:WaitForChild("PlayerGui")
	ReplicatedFirst:RemoveDefaultLoadingScreen()
	
	local function update()
		gui.CanvasGroup.Loading.Text = `STUDENTS LOADED ({#Players:GetPlayers()}/{teleportData.Amount})`
	end
	
	playerAddedConnection = Players.PlayerAdded:Connect(update)
	
	update()
	local CurtainService = require(ReplicatedStorage:WaitForChild("Services"):WaitForChild("CurtainService"))
	ReplicatedStorage:WaitForChild("Communication"):WaitForChild("Load"):WaitForChild("Done").OnClientEvent:Connect(function()
		--CurtainService:Show()
		local textTween = TweenService:Create(
			script.Parent.CanvasGroup.Loading,
			info3,
			{
				TextTransparency = 1
			}
		)
		textTween:Play()
		local groupTween = TweenService:Create(
			script.Parent.CanvasGroup,
			info3,
			{
				GroupTransparency = 1
			}
		)
		groupTween:Play()
		groupTween.Completed:Wait()
		task.wait(0.5)
		gui:Destroy()	
	end)
end



