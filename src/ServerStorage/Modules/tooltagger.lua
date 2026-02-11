local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)
local ServerStorage = game:GetService("ServerStorage")

local Tool = require(ServerStorage.Classes.Tool)

local Tools = {}

return function()
	for _, tool in TagService:GetTaggedOfAncestor(workspace, "Tool") do
		Tools[tool] = Tool.new(tool)
	end
	
	TagService:GetInstanceAddedSignal("Tool"):Connect(function(tool)
		Tools[tool] = Tool.new(tool)
	end)
	
end