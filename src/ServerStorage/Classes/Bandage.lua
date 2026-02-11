local ServerStorage = game:GetService("ServerStorage")

local Healer = require(ServerStorage.Classes.Healer)

local Bandage = {}
Bandage.__index = Bandage
setmetatable(Bandage, Healer)

function Bandage.new(bandage: Tool)
	local self = setmetatable(Healer.new(bandage, 10, "Bandage"), Bandage)
	return self
end

return Bandage