local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Info = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local VitalsGui = ReplicatedStorage.Props.VitalsGui

local VitalsService = {}

function VitalsService:Create()
	VitalsService.Gui = VitalsGui:Clone()
	VitalsService.Gui.Parent = PlayerGui
	VitalsService.HungerGauge = VitalsService.Gui.Main.Hunger.GaugeHolder.Gauge
	VitalsService.HealthGauge = VitalsService.Gui.Main.Health.GaugeHolder.Gauge
	VitalsService.HungerValue = 100
end

function VitalsService:SetHunger(n: number)
	VitalsService.HungerValue = n
	local tween = TweenService:Create(
		VitalsService.HungerGauge,
		Info,
		{
			Size = UDim2.fromScale(VitalsService.HungerValue/100, VitalsService.HungerGauge.Size.Y.Scale)
		}
	)
	tween:Play()
end

function VitalsService:Destroy()
	if VitalsService.Gui then
		VitalsService.Gui:Destroy()
	end
end

return VitalsService