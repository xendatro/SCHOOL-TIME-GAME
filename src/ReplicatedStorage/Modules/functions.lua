local ServerStorage = game:GetService("ServerStorage")
local GameService = require(ServerStorage.Services.GameService)

local functions = {}

local goalNightModifiers = {1, 1.5, 2, 2.5, 3}

function functions.surprise()
	local alive = #GameService.Alive
	local value = 0.342424242*(alive^2) - 8*alive + 47.6545455
	if alive <= 2 then
		value += 10
	end
	return value
end

function functions.goalAmount(night)
	local alive = #GameService.Alive
	
	return math.clamp(4 + math.floor(goalNightModifiers[night] * alive), 0, 35)
end

function functions.gemAmount(night: number)
	local alive = #GameService.Alive
	return math.clamp(alive * (2 + night), 0, 50)
end

function functions.coinAmount(night: number)
	local alive = #GameService.Alive
	return math.clamp(30 + 10 * (night - 1) + alive, 0, 50)
end

return functions