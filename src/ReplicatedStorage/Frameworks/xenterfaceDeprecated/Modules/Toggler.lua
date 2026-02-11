local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Root = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Classes.Root)

local Settings = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Settings.Settings)

local Signal = require(ReplicatedStorage.Classes.Signal)
local Tagger = require(ReplicatedStorage.Classes.Tagger)

local Toggler = {}

Toggler.Binds = {}

Toggler.Toggled = Signal.new()

function Toggler:Start(root)
	Toggler.Tagger = Tagger.new(Settings.TogglerTag, root)
	Toggler.Tagger:AddFunction("Click", function(guiButton: GuiButton)
		return guiButton.MouseButton1Click:Connect(function()
			Toggler.Toggled:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
		end)
	end)
	
	local function bind(guiButton)
		local bind = guiButton:GetAttribute(Settings.Toggle_KeyBind)
		local valid = pcall(function()
			return Enum.KeyCode[bind]
		end)
		if valid then
			return UserInputService.InputBegan:Connect(function(inputObject)
				if inputObject.KeyCode == Enum.KeyCode[bind]
					and inputObject.UserInputState == Enum.UserInputState.Begin then
					Toggler.Toggled:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
				end
			end)
		end
	end
	
	Toggler.Tagger:AddFunction("Bind", bind)
	
	Toggler.Tagger:AddFunction("Changed", function(guiButton: GuiButton)
		return guiButton.AttributeChanged:Connect(function(attr)
			if attr == Settings.Toggle_KeyBind then
				local value = guiButton:GetAttribute(attr)
				if value then
					Toggler.Tagger:Unapply(guiButton, "Bind")
					Toggler.Tagger:Apply(guiButton, "Bind", bind)
				else
					Toggler.Tagger:Unapply(guiButton, "Bind")
				end
			end
		end)
	end)
end

function Toggler:Stop()
	Toggler.Tagger:Destroy()
end


return Toggler