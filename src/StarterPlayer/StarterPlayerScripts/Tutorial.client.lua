local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

Player.CharacterAdded:Wait()

local Backpack = Player:WaitForChild("Backpack")

local arrows = {}

local tutorialState = 1

local connection
connection = CollectionService:GetInstanceAddedSignal("Object"):Connect(function(instance)
	if tutorialState ~= 1 then return end
	if arrows[instance] then return end
	if instance:GetAttribute("Type") == "WoodPlank" then
		print("YO WE FOUND A PLANKKK")
		local clone = script.ArrowPart:Clone()
		clone:PivotTo(instance:GetPivot())
		clone.Parent = workspace
		arrows[instance] = clone
		
		instance.Destroying:Once(function()
			clone:Destroy()
			arrows[instance] = nil
		end)
	end
end)

print(Backpack)

local connection2
local connection3 
connection2 = Backpack.ChildAdded:Connect(function(item)
	print("item added")
	if item.Name == "WoodPlank" then
		print("item added is woodplank")
		tutorialState = 2
		connection:Disconnect()
		connection2:Disconnect()
		for _, v in arrows do
			print(v)
			v:Destroy()
		end
		
		workspace.Important.DeliverArea.Main.BillboardGui.Enabled = true
		
		connection3 = Backpack.ChildRemoved:Connect(function(item)
			if item.Name == "WoodPlank" then
				workspace.Important.DeliverArea.Main.BillboardGui.Enabled = false
				connection3:Disconnect()
				
				Player.PlayerGui.GoalGui.Arrow.Visible = true
				task.delay(5, function()
					Player.PlayerGui.GoalGui.Arrow.Visible = false
				end)
			end
		end)
	end
end)

