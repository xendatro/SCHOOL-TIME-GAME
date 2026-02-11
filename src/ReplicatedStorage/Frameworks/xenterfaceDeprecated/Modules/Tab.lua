local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)
local UserInputService = game:GetService("UserInputService")

local Root = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Classes.Root)

local Settings = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Settings.Settings)

local Tagger = require(ReplicatedStorage.Classes.Tagger)
local Signal = require(ReplicatedStorage.Classes.Signal)

local Tab = {}

Tab.Clicked = Signal.new()


function Tab:Start(root)
	Tab.Tagger = Tagger.new(Settings.TabTag, root)
	Tab.Tagger:AddFunction("Tab", function(guiButton: GuiButton)
		return guiButton.MouseButton1Click:Connect(function()
			Tab.Clicked:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
		end)
	end)
	
	local function bind(guiButton)
		local bind = guiButton:GetAttribute(Settings.Page_KeyBind)
		local valid = pcall(function()
			return Enum.KeyCode[bind]
		end)
		if valid then
			return UserInputService.InputBegan:Connect(function(inputObject)
				if inputObject.KeyCode == Enum.KeyCode[bind]
					and inputObject.UserInputState == Enum.UserInputState.Begin then
					Tab.Clicked:Fire(guiButton, Root:FindFirstRootAncestorFromInstance(guiButton))
				end
			end)
		end
	end
	
	Tab.Tagger:AddFunction("Bind", bind)

	Tab.Tagger:AddFunction("Changed", function(guiButton: GuiButton)
		return guiButton.AttributeChanged:Connect(function(attr)
			if attr == Settings.Page_KeyBind then
				local value = guiButton:GetAttribute(attr)
				if value then
					Tab.Tagger:Unapply(guiButton, "Bind")
					Tab.Tagger:Apply(guiButton, "Bind", bind)
				else
					Tab.Tagger:Unapply(guiButton, "Bind")
				end
			end
		end)
	end)
	
end

function Tab:Stop()
	Tab.Tagger:Destroy()
end

return Tab