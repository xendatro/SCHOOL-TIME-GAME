local ServerStorage = game:GetService("ServerStorage")
local CutsceneService = require(ServerStorage.Services.CutsceneService)

local Day = require(ServerStorage.Classes.Day)

return function()
	local day = Day.new(3)
	task.delay(2, function()
		CutsceneService:Play("GenericDay")
	end)
	day:Start()
end