local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)

local table = require(ReplicatedStorage.Libraries.table)

local Tagger = {}
Tagger.__index = Tagger

function Tagger.new(tag: string, ancestor: Instance)
	local self = setmetatable({}, Tagger)
	
	self.Tag = tag
	self.Ancestor = ancestor
	self.Instances = {} --[[
		Instance = {
			Connection1 = Connection,
			Connection2 = Connection
		}
	]]
	self.Functions = {}
	self.Connections = {}
	
	self:SetUpConnections()
	self:SetUpInstances()
	
	return self	
end

function Tagger:AddInstance(instance)
	if self.Instances[instance] then return end
	self.Instances[instance] = {}
	for name, f in self.Functions do
		self.Instances[instance][name] = f(instance)
	end
end

function Tagger:RemoveInstance(instance)
	table.fullclear(self.Instances[instance])
	self.Instances[instance] = nil
end

--Add a SPECIFIC connection to a SPECIFIC instance's connection table
function Tagger:Apply(instance: Instance, name: string, f: (instance: Instance) -> RBXScriptConnection) 
	self.Instances[instance][name] = f(instance)
end

--Remove a SPECIFIC connection from a SPECIFIC instance's connection table
function Tagger:Unapply(instance: Instance, name: string)
	if self.Instances[instance][name] == nil then return end
	self.Instances[instance][name]:Disconnect()
	self.Instances[instance][name] = nil
end

--Add a SPECIFIC connection to ALL instances' connection tables
function Tagger:ApplyAll(name: string, f: (instance: Instance) -> RBXScriptConnection)
	for instance, t in self.Instances do
		self:Apply(instance, name, f)
	end
end

--Remove a SPECIFIC connection from ALL instances' connection tables
function Tagger:UnapplyAll(name: string)
	for instance, t in self.Instance do
		self:Unapply(instance, name)
	end
end

function Tagger:AddFunction(name: string, f: (instance: Instance) -> RBXScriptConnection)
	self.Functions[name] = f
	self:ApplyAll(name, f)
end

function Tagger:RemoveFunction(name: string)
	self.Functions[name] = nil
	self:UnapplyAll(name)
end


function Tagger:SetUpConnections()
	self.Connections["Added"] = TagService:GetInstanceAddedSignal(self.Tag):Connect(function(instance: Instance)
		if not instance:IsDescendantOf(self.Ancestor) then return end
		self:AddInstance(instance)
	end)
	self.Connections["Removed"] = TagService:GetInstanceRemovedSignal(self.Tag):Connect(function(instance: Instance)
		if not instance:IsDescendantOf(self.Ancestor) then return end
		self:RemoveInstance(instance)
	end) 
	self.Connections["DescendentAdded"] = self.Ancestor.DescendantAdded:Connect(function(guiObject: GuiObject)
		if guiObject:HasTag(self.Tag) then
			self:AddInstance(guiObject)
		end
	end)
	self.Connections["DescendantRemoving"] = self.Ancestor.DescendantRemoving:Connect(function(guiObject: GuiObject)
		if guiObject:HasTag(self.Tag) then
			self:RemoveInstance(guiObject)
		end
	end)
end

function Tagger:SetUpInstances()
	for k, instance in TagService:GetTagged(self.Tag) do
		if not instance:IsDescendantOf(self.Ancestor) then continue end
		self.Instances[instance] = {}
	end
end

function Tagger:Destroy()
	table.fullclear(self.Connections)
	table.fullclear(self.Instances)
end

return Tagger