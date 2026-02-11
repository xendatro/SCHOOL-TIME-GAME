local humanoid: Humanoid = script.Parent:WaitForChild("Humanoid")

humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)