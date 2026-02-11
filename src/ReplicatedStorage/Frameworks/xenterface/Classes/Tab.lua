local FunctionService = require(script.Parent.Parent.Services.FunctionService)

local Settings = require(script.Parent.Parent.Settings.Settings)

local Tab = {}
Tab.__index = Tab

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Input = self.Button[self.Tab:GetAttribute(Settings.InputAttribute) or "MouseButton1Click"]:Connect(function()
		FunctionService:Fire(
			self.Tab:GetAttribute(Settings.GroupAttribute),
			self.Tab:GetAttribute(Settings.IdAttribute),
			self.Button
		)
	end)
end

function Tab.new(tab: GuiButton | Configuration)
	local self = setmetatable({}, Tab)

	self.Tab = tab
	self.Button = if not tab:IsA("GuiButton") then tab.Parent else tab

	setUpConnections(self)

	return self
end

function Tab:Destroy()
	if self.Connections.MouseButton1Click then
		self.Connections.MouseButton1Click:Disconnect()
	end
end

return Tab