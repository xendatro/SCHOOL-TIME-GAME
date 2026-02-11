local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectService = require(ReplicatedStorage.Services.ObjectService)
local ServerStorage = game:GetService("ServerStorage")

local Classes = ServerStorage.Classes

local Grab = require(Classes.Grab)
local FoodTool = require(Classes.FoodTool)
local Locker = require(Classes.Locker)
local Trap = require(Classes.Trap)
local TrapObject = require(Classes.TrapObject)
local Tool = require(Classes.Tool)
local SpellBook = require(Classes.SpellBook)
local Bandage = require(Classes.Bandage)
local Medkit = require(Classes.Medkit)
local EvilLocker = require(Classes.EvilLocker)
local ElectricWire = require(Classes.ElectricWire)

return function()
	ObjectService:CreateObjectifier("Grab",
		function(grab)
			return Grab.new(grab)
		end,
		function()
		end,
		workspace
	)
	ObjectService:CreateObjectifier("FoodTool",
		function(foodTool)
			return FoodTool.new(foodTool)
		end,
		function()
		end,
		workspace
	)
	ObjectService:CreateObjectifier("Locker",
		function(locker)
			return Locker.new(locker)
		end,
		function() end,
		workspace
	)
	ObjectService:CreateObjectifier("TrapObject",
		function(trap)
			return TrapObject.new(trap)
		end,
		function() end,
		workspace
	)
	ObjectService:CreateObjectifier("Tool",
		function(tool)
			return Tool.new(tool)
		end,
		function () end,
		workspace
	)
	ObjectService:CreateObjectifier("Trap",
		function(trap)
			return Trap.new(trap)
		end,
		function() end
	)
	ObjectService:CreateObjectifier("SpellBook",
		function(spellBook)
			return SpellBook.new(spellBook)
		end,
		function() end
	)
	ObjectService:CreateObjectifier("Bandage",
		function(bandage)
			return Bandage.new(bandage)
		end,
		function() end
	)
	ObjectService:CreateObjectifier("Medkit",
		function(medkit)
			return Medkit.new(medkit)
		end,
		function() end
	)
	ObjectService:CreateObjectifier("EvilLocker",
		function(evilLocker)
			return EvilLocker.new(evilLocker)
		end,
		function() end
	)
	ObjectService:CreateObjectifier("ElectricWire",
		function(electricWire)
			return ElectricWire.new(electricWire)
		end,
		function() end
	)
end