local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)

local Settings = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Settings.Settings)

local Root = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Classes.Root)

local table = require(ReplicatedStorage.Libraries.table)
local Tagger = require(ReplicatedStorage.Classes.Tagger)
local Signal = require(ReplicatedStorage.Classes.Signal)

local Hover = {}

Hover.Enter = Signal.new()
Hover.Leave = Signal.new()

function Hover:Start(root)
	Hover.Tagger = Tagger.new(Settings.HoverTag, root)
	
	Hover.Tagger:AddFunction("Default", function(guiButton: GuiButton)
		if guiButton:GetAttribute(Settings.Hover_DefaultSize) == nil then
			guiButton:SetAttribute(Settings.Hover_DefaultSize, guiButton.Size)
		end
	end)
	
	Hover.Tagger:AddFunction("Enter", function(guiButton: GuiButton)
		return guiButton.MouseEnter:Connect(function()
			Hover.Enter:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
		end)
	end)
	
	Hover.Tagger:AddFunction("Leave", function(guiButton: GuiButton)
		return guiButton.MouseLeave:Connect(function()
			Hover.Leave:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
		end)
	end)
	
	
	Hover.Connections = {
		Enter = Hover.Enter:Connect(function(guiButton, root)
			local entered = Root:GetFunction(root, "Hover", "Entered", guiButton:GetAttribute(Settings.Hover_Class))
			entered(guiButton)
		end),
		Leave = Hover.Leave:Connect(function(guiButton, root)
			local left = Root:GetFunction(root, "Hover", "Left", guiButton:GetAttribute(Settings.Hover_Class))
			left(guiButton)
		end)
	}
end

function Hover:Stop()
	table.fullclear(Hover.Connections)
	Hover.Tagger:Destroy()
end


return Hover
