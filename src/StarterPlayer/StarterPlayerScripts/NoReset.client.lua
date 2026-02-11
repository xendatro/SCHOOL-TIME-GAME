local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

while RunService.RenderStepped:Wait() do
	local success = pcall(function()
		StarterGui:SetCore("ResetButtonCallback", false)
	end)
	if success then break end
end