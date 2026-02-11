local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)

local Settings = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Settings.Settings)

local Root = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Classes.Root)

local Toggler = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Modules.Toggler)
local table = require(ReplicatedStorage.Libraries.table)


local Toggleable = {}


local function toggle(guiButton: GuiButton, root)
	local groupID = guiButton:GetAttribute(Settings.Toggle_GroupID)
	
	table.foreach(TagService:GetTaggedOfPredicate(Settings.ToggleableTag, function(toggleable: GuiObject)
		return toggleable:GetAttribute(Settings.Toggle_GroupID) == groupID
			and toggleable:IsDescendantOf(root)
	end), function(index: number, toggleable: GuiObject)
		toggleable:SetAttribute(Settings.Toggle_Open, not toggleable:GetAttribute(Settings.Toggle_Open))
	end)

	local openToggleables = TagService:GetTaggedOfPredicate(Settings.ToggleableTag, function(toggleable: GuiObject)
		return toggleable:GetAttribute(Settings.Toggle_GroupID) == groupID 
			and toggleable:GetAttribute(Settings.Toggle_Open)
			and toggleable:IsDescendantOf(root)
	end)
	local openedToggleable = Root:GetFunction(root, "Toggle", "OpenedToggleable", groupID)
	for k, v in openToggleables do
		openedToggleable(v)
	end
	

	local closeToggleables = TagService:GetTaggedOfPredicate(Settings.ToggleableTag, function(toggleable: GuiObject)
		return toggleable:GetAttribute(Settings.Toggle_GroupID) == groupID
			and toggleable:GetAttribute(Settings.Toggle_Open) == false
			and toggleable:IsDescendantOf(root)
	end)
	local closedToggleable = Root:GetFunction(root, "Toggle", "ClosedToggleable", groupID)
	for k, v in closeToggleables do
		closedToggleable(v)
	end

end

function Toggleable:Start()
	Toggleable.Connections = {
		Toggled = Toggler.Toggled:Connect(function(guiButton: GuiButton, root)
			toggle(guiButton, root)
		end)
	}
end

function Toggleable:Stop()
	table.fullclear(Toggleable.Connections)
end


return Toggleable