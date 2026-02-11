local Players = game:GetService("Players")
local TagService = require(game:GetService("ReplicatedStorage").Services.TagService)
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local table = require(game:GetService("ReplicatedStorage").Libraries.table)

local PlayerGui = Player:WaitForChild("PlayerGui")

local CustomPage = require(script.Parent.CustomPage)
local CustomToggle = require(script.Parent.CustomToggle)
local CustomHover = require(script.Parent.CustomHover)

local Settings = require(game:GetService("ReplicatedStorage").Frameworks.xenterfaceDeprecated.Settings.Settings)

local Root = {}
Root.__index = Root

local function distance(ancestor, descendant)
	if descendant == ancestor or descendant == nil then
		return 0
	else
		return 1 + distance(ancestor, descendant.Parent)
	end
end

local BasePage = CustomPage.new()

BasePage.ShownTab = Settings.BaseShownTab
BasePage.HiddenTab = Settings.BaseHiddenTab
BasePage.ShownPage = Settings.BaseShownPage
BasePage.HiddenPage = Settings.BaseHiddenPage

local BaseToggle = CustomToggle.new()	

BaseToggle.OpenedToggleable = Settings.BaseOpenedToggleable
BaseToggle.ClosedToggleable = Settings.BaseClosedToggleable

local BaseHover = CustomHover.new()

BaseHover.Entered = Settings.BaseEntered
BaseHover.Left = Settings.BaseLeft

local Roots = {}

Root.Roots = Roots

Root.Root = PlayerGui

Root.BaseFunctions = {
	Page = BasePage,
	Toggle = BaseToggle,
	Hover = BaseHover
	
}
Root.IDFunctions = {
	Page = {},
	Toggle = {},
	Hover = {}
}

function Root.new(instance)
	local self = setmetatable({}, Root)
	
	self.Root = instance
	self.IDFunctions = {
		Page = {},
		Toggle = {},
		Hover = {}
	}
	self.BaseFunctions = {
		Page = {},
		Toggle = {},
		Hover = {}
	}
	
	return self
end

function Root:Create(id: string) --yields
	local instance = self:WaitForSubRoot(id)
	Roots[instance] = self.new(instance)
	return Roots[instance] :: typeof(Root)
end

function Root:WaitForSubRoot(rootID: string, t: number)
	local root = self:FindFirstSubRoot(rootID)
	if root then
		return root 
	end
	local connection = self.Root.DescendantAdded:Connect(function(descendant)
		if descendant:HasTag(Settings.RootTag) and descendant:GetAttribute(Settings.Root_ID) == rootID then
			root = descendant
		end 
	end)
	local start = os.clock()
	repeat RunService.RenderStepped:Wait() until root ~= nil
	connection:Disconnect()
	if root == nil then
		error("No root in time.")
	end
	return root
end

local function findClosest(root, t)
	local first = nil
	local firstheight = nil
	for k, currentRoot in t do
		local height = distance(root, currentRoot)
		if first == nil or height < firstheight then
			first = currentRoot
			firstheight = height
		end
	end
	return first
end

function Root:FindFirstSubRoot(rootID: string)
	local roots = TagService:GetTaggedOfPredicate(Settings.RootTag, function(instance: Instance)
		return instance:IsDescendantOf(self.Root) and instance:GetAttribute(Settings.Root_ID) == rootID
	end)
	return findClosest(self.Root, roots)
end

function Root:Find(id: string)
	local descendants = table.filter(self.Root:GetDescendants(), function(instance: Instance)
		return instance:GetAttribute(Settings.ID) == id
	end)
	return findClosest(self.Root, descendants)
end

function Root:Wait(id: string, t: number)
	local element = self:Find(id)
	if element then
		return element 
	end
	local connection = self.Root.DescendantAdded:Connect(function(descendant)
		if descendant:GetAttribute(Settings.ID) == id then
			element = descendant
		end 
	end)
	local start = os.clock()
	repeat RunService.RenderStepped:Wait() until os.clock() - start > (t or 3) or element ~= nil
	connection:Disconnect()
	if element == nil then
		error("No element in time.")
	end
	return element
end

function Root:GetFunction(rootInstance: Instance, system: string, name: string, groupID: string)
	local current = rootInstance
	while current ~= nil and current ~= Root.Root.Parent do
		if Roots[current] and Roots[current].IDFunctions[system][groupID] and Roots[current].IDFunctions[system][groupID][name] then
			return Roots[current].IDFunctions[system][groupID][name]
		end
		current = current.Parent
	end
	if Root.IDFunctions[system][groupID] and Root.IDFunctions[system][groupID][name] then
		return Root.IDFunctions[system][groupID][name]
	end
	current = rootInstance
	while current ~= nil and current ~= Root.Root.Parent do
		if Roots[current] and Roots[current].BaseFunctions[system][name] then
			return Roots[current].BaseFunctions[system][name]
		end
		current = current.Parent
	end
	return Root.BaseFunctions[system][name]
end

function Root:FindFirstRootAncestor()
	if self.Root == PlayerGui then
		return nil
	end
	local curr = self.Root
	repeat curr = curr.Parent until curr:HasTag(Settings.RootTag) or curr == PlayerGui
	return curr
end

function Root:FindFirstRootAncestorFromInstance(instance: Instance)
	local curr = instance
	repeat curr = curr.Parent until curr:HasTag(Settings.RootTag) or curr == PlayerGui
	return curr
end

function Root:CustomPage(groupID: string)
	local customPage = self.IDFunctions.Page[groupID] or CustomPage.new()
	self.IDFunctions.Page[groupID] = customPage
	return customPage
end

function Root:CustomToggle(groupID: string)
	local customToggle = self.IDFunctions.Toggle[groupID] or CustomToggle.new()
	self.IDFunctions.Toggle[groupID] = customToggle
	return customToggle
end

function Root:CustomHover(className: string)
	local customHover = self.IDFunctions.Hover[className] or CustomHover.new()
	self.IDFunctions.Hover[className] = customHover
	return customHover
end

function Root:BasePage()
	local customPage = self.BaseFunctions.Page or CustomPage.new()
	self.BaseFunctions.Page = customPage
	return customPage
end

function Root:BaseToggle()
	local customToggle = self.BaseFunctions.Toggle or CustomToggle.new()
	self.BaseFunctions.Toggle = customToggle
	return customToggle
end

function Root:BaseHover()
	local customHover = self.BaseFunctions.Hover or CustomHover.new()
	self.BaseFunctions.Hover = customHover
	return customHover
end

return Root