local ServerStorage = game:GetService("ServerStorage")

local Healer = require(ServerStorage.Classes.Healer)

local Medkit = {}
Medkit.__index = Medkit
setmetatable(Medkit, Healer)

function Medkit.new(medkit: Tool)
	local self = setmetatable(Healer.new(medkit, 45, "Medkit"), Medkit)
	return self
end

return Medkit