local Players = game:GetService("Players")
local TagService = require(script.Parent.Parent.Services.TagService)

local Player = Players.LocalPlayer
local PlayerGui: Instance = Player:WaitForChild("PlayerGui")

local Settings = require(script.Parent.Parent.Settings.Settings)

local Tab = require(script.Parent.Parent.Classes.Tab)

local Tabs = {}

local function createTab(tab)
	Tabs[tab] = Tab.new(tab)
end

local function deleteTab(tab)
	if Tabs[tab] then
		Tabs[tab]:Destroy()
		Tabs[tab] = nil
	end
end

return function()
	for _, tab in TagService:GetTaggedOfAncestor(PlayerGui, Settings.TabTag) do
		createTab(tab)
	end
	
	PlayerGui.DescendantAdded:Connect(function(descendant: Instance)
		if descendant:HasTag(Settings.TabTag) then
			createTab(descendant)
		end
	end)
	
	PlayerGui.DescendantRemoving:Connect(function(descendant: Instance)
		if descendant:HasTag(Settings.TabTag) then
			deleteTab(descendant)
		end
	end)
	
	TagService:GetInstanceAddedSignal(Settings.TabTag):Connect(function(instance: Instance)
		if instance:IsDescendantOf(PlayerGui) then
			createTab(instance)
		end
	end)
	
	TagService:GetInstanceRemovedSignal(Settings.TabTag):Connect(function(instance: Instance)
		if instance:IsDescendantOf(PlayerGui) then
			deleteTab(instance)
		end
	end)
end