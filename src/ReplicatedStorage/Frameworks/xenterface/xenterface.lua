local FunctionService = require(script.Parent.Services.FunctionService)
local TagService = require(script.Parent.Services.TagService)
local Players = game:GetService("Players")

local Settings = require(script.Parent.Settings.Settings)

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")

require(script.Parent.Modules.tagger)()

local xenterface = {}

function xenterface:CreateFunction(pageGroup: string, f: (functionObject: FunctionService.FunctionObject) -> nil)
	FunctionService:Create(pageGroup, f)
end

function xenterface:DeleteFunction(pageGroup: string)
	FunctionService:Delete(pageGroup)
end

function xenterface:FireFunction(pageGroup: string, pageId: string | number, rawTab: GuiButton?)
	FunctionService:Fire(pageGroup, pageId, rawTab)
end

function xenterface:GetElementById(elementId: string)
	local elements = TagService:GetTaggedOfPredicate(Settings.ElementTag, function(v: Instance)
		return v:IsDescendantOf(PlayerGui) and v:GetAttribute(Settings.ElementIdAttribute) == elementId
	end)
	return elements[1]
end

function xenterface:GetElementsByClass(elementClass: string)
	return TagService:GetTaggedOfPredicate(Settings.ElementTag, function(v: Instance)
		return v:IsDescendantOf(PlayerGui) and v:GetAttribute(Settings.ElementClassAttribute) == elementClass
	end)
end

return xenterface