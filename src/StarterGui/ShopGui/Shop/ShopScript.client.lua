local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local openInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local closeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local ShopSettings = require(ReplicatedStorage.Settings.ShopSettings)

local xenterface = require(ReplicatedStorage.Frameworks.xenterface.xenterface)

local currentItem = nil

local function viewporterize(viewportFrame, itemName)
	viewportFrame:ClearAllChildren()
	local item = ReplicatedStorage.Props.Viewports[itemName]:Clone()
	item.Parent = viewportFrame
	local camera = Instance.new("Camera")
	camera.Parent = viewportFrame
	viewportFrame.CurrentCamera = camera
	camera.CFrame = CFrame.new(0, 0, 4)
end

for itemName, data in ShopSettings.Items do
	local clone = script.Item:Clone()
	clone:SetAttribute("Item", itemName)
	clone:SetAttribute("Price", data.Price)
	clone:SetAttribute("Description", data.Description)
	
	viewporterize(clone.ViewportFrame, itemName)
	
	clone.Price.Text = data.Price
	clone.Parent = xenterface:GetElementById("ShopList")
end

xenterface:CreateFunction("SelectShop", function(functionObject)
	local display = functionObject.SelectedPages[1]
	local clicked = functionObject.RawTab
	if clicked:GetAttribute("Item") == nil then
		display.Visible = false
		currentItem = nil
	else
		display.Visible = true
		display.Title.Text = clicked:GetAttribute("Item")
		display.Cost.Coins.Text = clicked:GetAttribute("Price")
		display.Description.Text = clicked:GetAttribute("Description")
		viewporterize(display.ViewportFrame, clicked:GetAttribute("Item"))
		currentItem = clicked:GetAttribute("Item")
	end
end)

xenterface:CreateFunction("Shop", function(functionObject)
	for _, page in functionObject.SelectedPages do
		page.Visible = true
		TweenService:Create(
			page.UIScale,
			openInfo,
			{
				Scale = 1
			}
		):Play()
	end
	
	for _, page in functionObject.UnselectedPages do
		local tween = TweenService:Create(
			page.UIScale,
			closeInfo,
			{
				Scale = 0
			}
		)
		tween:Play()
		tween.Completed:Wait()
		page.Visible = false
	end
end)

xenterface:GetElementById("Purchase").MouseButton1Click:Connect(function()
	ReplicatedStorage.Communication.Shop.Purchase:FireServer(currentItem)
end)

ReplicatedStorage.Communication.Shop.Toggle.OnClientEvent:Connect(function(on)
	if on then
		xenterface:FireFunction("Shop", "Shop")
	else
		xenterface:FireFunction("Shop", "Close")
	end
end)