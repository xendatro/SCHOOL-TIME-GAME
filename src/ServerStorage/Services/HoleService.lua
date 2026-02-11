local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")


local Hole = ReplicatedStorage.Props.Other.Hole

local HoleService = {}

local HoleAreas = CollectionService:GetTagged("HoleArea")

function HoleService:CreateHolePair(position: Vector3)
	local hole1 = Hole:Clone()
	local hole2 = Hole:Clone()
	local x, y, z = Hole:GetPivot():ToOrientation()
	local id = HttpService:GenerateGUID()
	hole1:SetAttribute("ID", id)
	hole2:SetAttribute("ID", id)
	hole1:PivotTo(CFrame.new(position) * CFrame.fromOrientation(x, y, z))
	local holeArea = HoleAreas[math.random(1, #HoleAreas)]
	local size = holeArea.Size
	local position = holeArea.Position
	local offset = Vector3.new(math.random(-size.X/2, size.X/2), 0.5, math.random(-size.Z/2, size.Z/2))
	local randomPoint = position + offset
	hole2:PivotTo(CFrame.new(randomPoint) * CFrame.fromOrientation(x, y, z))
	hole1.Parent = workspace
	hole2.Parent = workspace
	return true
end

return HoleService