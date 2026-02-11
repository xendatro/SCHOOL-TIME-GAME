local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local BackpackService = require(ServerStorage.Services.BackpackService)
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local Spawns = ReplicatedStorage.Props.Spawns

local Tool = {}
Tool.__index = Tool

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.ParentChanged = self.Tool:GetPropertyChangedSignal("Parent"):Connect(function()
		if self.Tool.Parent == workspace then
			self:Drop()
		end
	end)
	self.Connections.Equipped = self.Tool.Equipped:Connect(function()
		self.Character = self.Tool.Parent
	end)
	
end

function Tool.new(tool: Tool)
	local self = setmetatable({}, Tool)
	
	self.Tool = tool
	
	setUpConnections(self)
	
	return self
end

function Tool:Drop()
	if self.Tool:GetAttribute("quantity") > 1 then
		self.Tool.Parent = self.Character
	else
		self.Tool:Destroy()
	end
	local cframe = if self.Character then self.Character:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2)) else self.Tool.WorldPivot
	local clone = Spawns:FindFirstChild(self.Tool.Name):Clone()
	clone:PivotTo(cframe)
	clone.Parent = workspace
	BackpackService:Remove(Players:GetPlayerFromCharacter(self.Character), self.Tool.Name, 1)
end


return Tool