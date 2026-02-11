--// SERVICES
local starterGui = game:GetService("StarterGui")
local contextActionService = game:GetService("ContextActionService")
local userInputService = game:GetService("UserInputService")

--// PLAYER
local player = game:GetService("Players").LocalPlayer
local playerBackPack = player:WaitForChild("Backpack")
local currentCamera = workspace.CurrentCamera

--// INVENTORY_SYSTEM \\--
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local CustomInventoryGUI = script.Parent
local hotBar = CustomInventoryGUI.hotBar
local Inventory = CustomInventoryGUI.Inventory
local toolSlot = script.toolSlot

local inventoryHandler = require(script.inventoryHandler)

local function showSlots()
	for index = 1, inventoryHandler.slotAmount do
		local toolObject = inventoryHandler.OBJECTS.HotBar[index]
		if not toolObject and not hotBar:FindFirstChild(index) and index <= inventoryHandler.slotAmount then
			local frame = toolSlot:Clone()
			frame.toolName.Text = ""
			frame.toolQuantity.Text = ""
			frame.toolNumber.Text = index
			frame.Name = index
			frame.Parent = hotBar
		end
	end
end
local function removeEmptySlots()
	for index = 1, 9 do
		local toolObject = inventoryHandler.OBJECTS.HotBar[index]
		local toolFrame = hotBar:FindFirstChild(index)
		if not toolObject and toolFrame then
			toolFrame:Destroy()
			if hotBar:FindFirstChild(index) then
				removeEmptySlots()
			end
		end
	end
end

local function manageInventory (_, inputState)
	if inputState == Enum.UserInputState.Begin then
		Inventory.Visible = not Inventory.Visible
		local currentState = Inventory.Visible

		inventoryHandler:removeCurrentDescription()
		if currentState then
			showSlots()
		else
			if not inventoryHandler.SETTINGS.SHOW_EMPTY_TOOL_FRAMES_IN_HOTBAR then
				removeEmptySlots()
			end
		end
	elseif not inputState then
		for index = inventoryHandler.slotAmount + 1, inventoryHandler.slotAmount do
			local toolObject = inventoryHandler.OBJECTS.HotBar[index]
			local toolFrame = hotBar:FindFirstChild(index)
			if toolObject then
				local tool = toolObject.Tool
				toolObject:DisconnectAll()
				tool:SetAttribute("toolAdded", nil)
				inventoryHandler:newTool(tool)
			elseif toolFrame then
				toolFrame:Destroy()
			end
		end
	end
end

local function searchTool()
	inventoryHandler:searchTool()
end
local function newTool(tool)
	if tool:IsA("Tool") then
		inventoryHandler:newTool(tool)
	end
end

local function reloadInventory(character)
	inventoryHandler.currentlyEquipped = nil
	playerBackPack = player:WaitForChild("Backpack")

	for _, tool in pairs(playerBackPack:GetChildren()) do
		if tool:IsA("Tool") then
			newTool(tool)
		end
	end
	playerBackPack.ChildAdded:Connect(newTool)
	character.ChildAdded:Connect(newTool)
end
local function updateHudPosition()
	local viewPortSize = currentCamera.ViewportSize
	local slotSize = UDim2.fromOffset(hotBar.AbsoluteSize.Y, hotBar.AbsoluteSize.Y)
	
	Inventory.Frame.Grid.CellSize = slotSize
	hotBar.Grid.CellSize = slotSize

	manageInventory()
end

updateHudPosition(); updateHudPosition()
reloadInventory(player.Character or player.CharacterAdded:Wait())
currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateHudPosition)
player.CharacterAdded:Connect(reloadInventory)
--Inventory.SearchBox:GetPropertyChangedSignal("Text"):Connect(searchTool)
if inventoryHandler.SETTINGS.SHOW_EMPTY_TOOL_FRAMES_IN_HOTBAR then showSlots() end
if inventoryHandler.SETTINGS.INVENTORY_KEYBIND then contextActionService:BindAction("manageInventory", manageInventory, false, inventoryHandler.SETTINGS.INVENTORY_KEYBIND) end

local function getToolEquipped()
	local character = player.Character
	return character and character:FindFirstChildOfClass("Tool")
end


userInputService.InputChanged:Connect(function(input) -- 1 up, -1 down
	if input.UserInputType == Enum.UserInputType.MouseWheel and inventoryHandler.SETTINGS.SCROLL_HOTBAR_WITH_WHEEL then
		local direction = input.Position.Z
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		local toolEquipped = getToolEquipped()
		local toolPosition = inventoryHandler:getToolPosition(toolEquipped) or 0
		
		for i=toolPosition + direction, direction < 0 and 1 or inventoryHandler.slotAmount, direction do
			local toolObject = inventoryHandler.OBJECTS.HotBar[i]
			if toolObject and humanoid then
				humanoid:EquipTool(toolObject.Tool)
				break
			end
		end
	end
end)

local function onChange(direction)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	local toolEquipped = getToolEquipped()
	local toolPosition = inventoryHandler:getToolPosition(toolEquipped) or 0

	for i=toolPosition + direction, direction < 0 and 1 or inventoryHandler.slotAmount, direction do
		local toolObject = inventoryHandler.OBJECTS.HotBar[i]
		if toolObject and humanoid then
			humanoid:EquipTool(toolObject.Tool)
			break
		end
	end
end

contextActionService:BindAction("BumperRight", function(actionName, inputState)
	if inputState ~= Enum.UserInputState.Begin then return end
	onChange(1)
end, false, Enum.KeyCode.ButtonR1)
contextActionService:BindAction("BumperLeft", function(actionName, inputState)
	if inputState ~= Enum.UserInputState.Begin then return end
	onChange(-1)
end, false, Enum.KeyCode.ButtonL1)