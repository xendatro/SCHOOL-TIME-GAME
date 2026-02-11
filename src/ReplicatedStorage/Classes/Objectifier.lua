local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)

local ObjectSettings = require(script.Parent.Parent.Settings.ObjectSettings)

--[[Objectifier]]
local Objectifier = {}
Objectifier.__index = Objectifier

--Private Methods
local function apply(self: typeof(Objectifier.new()), instance: Instance)
	if self.Objects[instance] then return end
	self.Objects[instance] = self.ApplyFunction(instance)
end

local function unapply(self: typeof(Objectifier.new()), instance: Instance)
	self.UnapplyFunction(instance, self.Objects[instance])
	self.Objects[instance] = nil
end

local function isClass(instance, className)
	return instance:GetAttribute(ObjectSettings.ClassAttribute) == className
end

local function setUpConnections(self: typeof(Objectifier.new()))
	self.Connections = {}
	self.InstanceAdded = TagService:GetInstanceAddedSignal(ObjectSettings.ObjectTag):Connect(function(instance: Instance)
		if not isClass(instance, self.ClassName) then return end
		if not instance:IsDescendantOf(self.Ancestor) then return end
		apply(self, instance)
	end)
	self.InstanceRemoved = TagService:GetInstanceRemovedSignal(ObjectSettings.ObjectTag):Connect(function(instance: Instance)
		if not isClass(instance, self.ClassName) then return end
		unapply(self, instance)
	end)
	if self.Ancestor then
		self.DescendantAdded = self.Ancestor.DescendantAdded:Connect(function(descendant)
			if descendant:HasTag(ObjectSettings.ObjectTag) and descendant:GetAttribute(ObjectSettings.ClassAttribute) == self.ClassName then
				apply(self, descendant)
			end
		end)
		self.DescendantRemoving = self.Ancestor.DescendantRemoving:Connect(function(descendant)
			if descendant:HasTag(ObjectSettings.ObjectTag) and descendant:GetAttribute(ObjectSettings.ClassAttribute) == self.ClassName then
				unapply(self, descendant)
			end
		end)
	end
end

local function initialize(self)
	for _, instance in TagService:GetTagged(ObjectSettings.ObjectTag) do
		if not isClass(instance, self.ClassName) then continue end
		if not instance:IsDescendantOf(self.Ancestor) then continue end
		apply(self, instance)
	end
end

function Objectifier.new(className: string, applyFunction: (instance: Instance) -> any, unapplyFunction: (instance: Instance) -> any, ancestor: Instance?)
	local self = setmetatable({}, Objectifier)

	self.Objects = {}
	self.ClassName = className
	self.ApplyFunction = applyFunction
	self.UnapplyFunction = unapplyFunction
	self.Ancestor = ancestor

	setUpConnections(self)
	initialize(self)

	return self
end

function Objectifier:Get(instance: Instance)
	return self.Objects[instance]
end


return Objectifier