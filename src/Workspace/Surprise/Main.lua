local AudioService = require(game:GetService("ReplicatedStorage").Services.AudioService)


return function(player)
	task.wait(2)
	AudioService:Add3D("Vending", script.Parent.TeleportBlocks.Teacher, false, "Vending", 0.2)
	game.ReplicatedStorage.Communication.Shake.Create:FireClient(player, {
		ID = "Surprise",
		ShakeType = "Once",
		Preset = "Scare"
	})
	local on = function()
		for _, light in script.Parent.Lights:GetChildren() do
			light.SpotLight.Enabled = true
		end
	end
	local off = function()
		for _, light in script.Parent.Lights:GetChildren() do
			light.SpotLight.Enabled = false
		end
	end
	for i = 1, 10 do
		if i % 2 == 1 then
			off()
		else
			on()
		end
		task.wait(0.05)
	end
	on()
end