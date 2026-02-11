local ServerStorage = game:GetService("ServerStorage")

return function()
	for _, module in ServerStorage.Triggers:GetChildren() do
		require(module)
	end
end