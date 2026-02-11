local TweenService = game:GetService("TweenService")

local math = require(game:GetService("ReplicatedStorage").Libraries.math)

local Settings = {
	PageTag = "Page",
	TabTag = "Tab",
	TogglerTag = "Toggler",
	ToggleableTag = "Toggleable",
	RootTag = "Root",
	HoverTag = "Hover",
	
	Page_ID = "Page_ID",
	Page_GroupID = "Page_GroupID",
	Page_KeyBind = "Page_KeyBind",
	Page_Shown = "Page_Shown",
	Page_Mode = "Page_Mode", --Radio (default), Multi, Toggle
	
	Toggle_GroupID = "Toggle_GroupID",
	Toggle_Open = "Toggle_Open",
	Toggle_KeyBind = "Toggle_KeyBind",
	
	Class = "Class",
	ID = "ID",
	Root_ID = "Root_ID",
	
	Hover_Class = "Hover_Class",
	Hover_Multiplier = "Hover_Multiplier",
	Hover_DefaultSize = "Hover_DefaultSize",
	
	BaseOpenedToggleable = function(v) v.Visible = true end,
	BaseClosedToggleable = function(v) v.Visible = false end,
	
	BaseShownPage = function(v) v.Visible = true end,
	BaseHiddenPage = function(v) v.Visible = false end,
	BaseShownTab = function() end,
	BaseHiddenTab = function() end,	
}

function Settings.BaseEntered(v) 
	local multiplier = v:GetAttribute(Settings.Hover_Multiplier) or 1.05
	
	local xscale = math.nround(v.Size.X.Scale*multiplier, -3)
	local xoffset = math.nround(v.Size.X.Offset*multiplier, -3)
	local yscale = math.nround(v.Size.Y.Scale*multiplier, -3)
	local yoffset = math.nround(v.Size.Y.Offset*multiplier, -3)
	
	local newSize = UDim2.new(xscale, xoffset, yscale, yoffset)
	
	TweenService:Create(
		v,
		TweenInfo.new(0.05, Enum.EasingStyle.Linear),
		{
			Size = newSize
		}
	):Play()
end

function Settings.BaseLeft(v) 
	TweenService:Create(
		v,
		TweenInfo.new(0.05, Enum.EasingStyle.Linear),
		{
			Size = v:GetAttribute(Settings.Hover_DefaultSize)
		}
	):Play()
end

return Settings