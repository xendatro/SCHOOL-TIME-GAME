local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Delete = ReplicatedStorage.Communication.Backpack.Delete

local Blur = Lighting:WaitForChild("Blur")

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")
local RadarGui = PlayerGui:WaitForChild("RadarGui")

local Radar = {}
Radar.__index = Radar

local t = 10

local info = TweenInfo.new(0.5, Enum.EasingStyle.Linear)

local backIn = TweenService:Create(
	RadarGui:WaitForChild("CanvasGroup"),
	info,
	{
		GroupTransparency = 0
	}
)

local backOut = TweenService:Create(
	RadarGui:FindFirstChild("CanvasGroup"),
	info,
	{
		GroupTransparency = 1
	}
)

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Activated = self.Radar.Activated:Connect(function()
		self:Activated()
	end)
end

function Radar.new(radar)
	local self = setmetatable({}, Radar)
	
	self.Radar = radar
	self.Cooling = false
	
	self.On = false
	
	setUpConnections(self)
	
	return self
end

function Radar:Activated()
	if self.Cooling then return end
	self.Cooling = true
	if self.On == false then
		self.On = true
		self.Highlights = {}
		for _, antagonist in TagService:GetTaggedOfAncestor(workspace, "Antagonist") do
			local highlight = Instance.new("Highlight")
			highlight.Parent = antagonist
			table.insert(self.Highlights, highlight)
		end
		RadarGui.Enabled = true
		backIn:Play()
		Lighting.Blur.Size = 15
	else
		self.On = false
		for _, highlight in self.Highlights do
			highlight:Destroy()
		end
		Lighting.Blur.Size = 0
		backOut:Play()
		backOut.Completed:Wait()
		RadarGui.Enabled = false
		
	end
	task.wait(0.5)
	self.Cooling = false
	--[[
	if self.Cooling then return end
	self.Cooling = true
	local highlights = {}
	for _, antagonist in TagService:GetTaggedOfAncestor(workspace, "Antagonist") do
		local highlight = Instance.new("Highlight")
		highlight.Parent = antagonist
		table.insert(highlights, highlight)
	end
	RadarGui.Enabled = true
	backIn:Play()
	Lighting.Blur.Size = 15
	task.wait(t)
	for _, highlight in highlights do
		highlight:Destroy()
	end
	Lighting.Blur.Size = 0
	backOut:Play()
	backOut.Completed:Wait()
	RadarGui.Enabled = false
	self.Cooling = false]]
end

return Radar