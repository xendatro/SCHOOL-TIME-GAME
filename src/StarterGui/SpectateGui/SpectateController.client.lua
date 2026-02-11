local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local CircularLinkedList = require(ReplicatedStorage.Classes.CircularLinkedList)

local camera = workspace.CurrentCamera

local Spectate = {}
Spectate.__index = Spectate

local function getNext(iterator)
	local start = iterator:Get()
	iterator:Next()
	while iterator:Get().Character == nil or iterator:Get().Character:FindFirstChild("Humanoid") == nil or iterator:Get().Character.Humanoid.Health <= 0 do
		iterator:Next()
		if iterator:Get() == start then return end
	end
	return iterator:Get()
end

local function getPrevious(iterator)
	local start = iterator:Get()
	iterator:Previous()
	while iterator:Get().Character == nil or iterator:Get().Character:FindFirstChild("Humanoid") == nil or iterator:Get().Character.Humanoid.Health <= 0 do
		iterator:Previous()
		if iterator:Get() == start then return end
	end
	return iterator:Get()
end

local next: RBXScriptConnection
local previous: RBXScriptConnection

ReplicatedStorage.Communication.Spectate.Spectate.OnClientEvent:Connect(function(spectate: boolean)
	if spectate then
		script.Parent.Main.Visible = true
		print("-----")
		
		local list = CircularLinkedList.new(Players:GetPlayers())
		print(list.Head.Data)
		print(list.Head.Next.Data)
		print(list.Head.Next.Next.Data)

		local iterator = list:GetIterator()
		
		local player = getNext(iterator)
		print(player)
		if player == nil then return end
		camera.CameraSubject = player.Character
		script.Parent.Main.Username.Text = player.Name
		ReplicatedStorage.Communication.Spectate.SetFocus:FireServer(player)
		local showNext = function()
			local player = getNext(iterator)
			if player == nil then return end
			camera.CameraSubject = player.Character.Humanoid
			script.Parent.Main.Username.Text = player.Name
			ReplicatedStorage.Communication.Spectate.SetFocus:FireServer(player)
		end
		local showPrevious = function()
			local player = getPrevious(iterator)
			if player == nil then return end
			camera.CameraSubject = player.Character.Humanoid
			script.Parent.Main.Username.Text = player.Name
			ReplicatedStorage.Communication.Spectate.SetFocus:FireServer(player)
		end
		next = script.Parent.Main.Right.MouseButton1Click:Connect(function()
			showNext()
		end)
		previous = script.Parent.Main.Left.MouseButton1Click:Connect(function()
			showPrevious()
		end)
		
		ContextActionService:BindAction("ShowNext", function(_, inputState)
			if inputState ~= Enum.UserInputState.Begin then return end
			showNext()
		end, false, Enum.KeyCode.ButtonR1)
		
		ContextActionService:BindAction("ShowPrevious", function(_, inputState)
			if inputState ~= Enum.UserInputState.Begin then return end
			showPrevious()
		end, false, Enum.KeyCode.ButtonL1)
	else
		script.Parent.Main.Visible = false
		local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
		camera.CameraSubject = character:WaitForChild("Humanoid")
		ReplicatedStorage.Communication.Spectate.SetFocus:FireServer(Players.LocalPlayer)
		
		ContextActionService:UnbindAction("ShowNext")
		ContextActionService:UnbindAction("ShowPrevious")
	end
end)