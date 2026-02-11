local ServerStorage = game:GetService("ServerStorage")

local VitalsObject = require(ServerStorage.Classes.Vitals)

local VitalsService = {}

local Vitals = {}

function VitalsService:Create(player: Player)
	if VitalsService[player] then
		warn("Attempted to create a new Vitals object.")
		return
	end
	local vitals = VitalsObject.new(player, function()
		VitalsService:Destroy(player)
	end)
	Vitals[player] = vitals
end

function VitalsService:Destroy(player: Player)
	local vitals = Vitals[player]
	if vitals then
		vitals:Destroy()
	end
	Vitals[player] = nil
end

function VitalsService:ResumeAllHungers()
	for _, vitals in Vitals do
		vitals:ResumeHunger()
	end
end

function VitalsService:PauseAllHungers()
	for _, vitals in Vitals do
		vitals:PauseHunger()
	end
end

function VitalsService:GetVitals(player: Player)
	return Vitals[player]
end

return VitalsService