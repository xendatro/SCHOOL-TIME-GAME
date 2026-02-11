local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CustomPage = require(script.Classes.CustomPage)
local CustomToggle = require(script.Classes.CustomToggle)

local table = require(ReplicatedStorage.Libraries.table)

local Root = require(script.Classes.Root)

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")

local modules = table.map(script.Modules:GetChildren(), function(s)
	return require(s)
end)

local xenterface = {}

local mt = {
	__index = Root
}

setmetatable(xenterface, mt)

function xenterface:Start()
	table.foreach(modules, function(i, module)
		module:Start(PlayerGui)
	end)
end

function xenterface:Stop()
	table.foreach(modules, function(i, module)
		module:Stop()
	end)
end

function xenterface:GetCustomPage(groupID: string): typeof(CustomPage.new())
	local customPage = Settings.CustomPages[groupID] or CustomPage.new()
	Settings.CustomPages[groupID] = customPage
	return customPage
end

function xenterface:GetCustomToggle(groupID: string): typeof(CustomToggle.new())
	local customToggle = Settings.CustomToggles[groupID] or CustomToggle.new()
	Settings.CustomToggles[groupID] = customToggle
	return customToggle
end

return xenterface