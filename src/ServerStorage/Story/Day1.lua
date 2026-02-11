local ServerStorage = game:GetService("ServerStorage")
local CutsceneService = require(ServerStorage.Services.CutsceneService)

local Day = require(ServerStorage.Classes.Day)

return function()
	local day = Day.new(1)
	task.delay(2, function()
		CutsceneService:Play("Day1")		
	end)
	day:Start()
end