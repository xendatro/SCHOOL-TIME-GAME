local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectService = require(ReplicatedStorage.Services.ObjectService)

local Classes = ReplicatedStorage.Classes

local Soda = require(Classes.Soda)
local Radar = require(Classes.Radar)
local Ball = require(Classes.Ball)
local Shovel = require(Classes.Shovel)
local Hole = require(Classes.Hole)
local Visual = require(Classes.Visual)

return function()
	ObjectService:CreateObjectifier("Soda",
		function(soda)
			return Soda.new(soda)
		end,
		function()
		end
	)
	ObjectService:CreateObjectifier("Ball",
		function(ball)
			return Ball.new(ball)
		end,
		function()
		end
	)
	ObjectService:CreateObjectifier("Shovel",
		function(shovel)
			return Shovel.new(shovel)
		end,
		function()
		end
	)
	ObjectService:CreateObjectifier("Hole",
		function(hole)
			return Hole.new(hole)
		end,
		function()
		end
	)
	ObjectService:CreateObjectifier("Visual",
		function(visual)
			return Visual.new(visual)
		end,
		function(visual)
			visual:Destroy()
		end,
		workspace
	)
	ObjectService:CreateObjectifier("Radar",
		function(radar)
			return Radar.new(radar)
		end,
		function()
		end
	)
end