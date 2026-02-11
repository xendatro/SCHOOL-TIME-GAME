local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = workspace.CurrentCamera

local Visual = {}
Visual.__index = Visual

function Visual.new(visual: Model)
	local self = setmetatable({}, Visual)
	
	self.Visual = visual
	self.Visible = false
	
	self.Visual:WaitForChild("Hitbox")
	
	
	self:Start()
	
	return self
end

function Visual:Start()
	self.Engine = coroutine.create(function()
		while task.wait(0.5) do
			local visible = false
			if not self.Visual:FindFirstChild("Hitbox") then return end
			local instance = self.Visual.Hitbox
			local _, onScreen = Camera:WorldToScreenPoint(instance.Position)
			local result = workspace:Raycast(Camera.CFrame.Position, (instance.Position - Camera.CFrame.Position).Unit*300, RaycastParams.new())

			if onScreen and result and result.Instance:IsDescendantOf(self.Visual) then 
				visible = true
			end
			
			--[[
			for _, instance in self.Visual:GetChildren() do
				if instance:HasTag("Detect") then
					task.wait(0.5)
					local _, onScreen = Camera:WorldToScreenPoint(instance.Position)
					if not onScreen then continue end
					local result = workspace:Raycast(Camera.CFrame.Position, (instance.Position - Camera.CFrame.Position).Unit*300, RaycastParams.new())
					if not result or not result.Instance:IsDescendantOf(self.Visual) then continue end
					visible = true
					break
				end
			end
			]]
			if visible ~= self.Visible then
				self.Visible = visible
				ReplicatedStorage.Communication.Visual.Update:FireServer(self.Visual, self.Visible)
			end
		end		
	end)
	coroutine.resume(self.Engine)
end

function Visual:Destroy()
	self.Visible = false
	ReplicatedStorage.Communication.Visual.Update:FireServer(self.Visual, self.Visible)
	--print(self.Visible)
	if self.Engine then
		coroutine.close(self.Engine)
	end
end


return Visual