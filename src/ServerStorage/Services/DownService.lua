local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local GameService = require(ServerStorage.Services.GameService)


local Prompt = ReplicatedStorage.Props.Prompts.RevivePrompt
local Highlight = ReplicatedStorage.Props.General.ReviveHighlight

local DownService = {}



function DownService:Down(character)
	if character:HasTag("Ignore") then return end
	character:AddTag("Ignore")
	character:AddTag("Downed")
	character.Humanoid:TakeDamage(40)
	if character.Humanoid.Health <= 0 then return end
	local player = Players:GetPlayerFromCharacter(character)
	character.Humanoid:UnequipTools()
	for _, tool: Tool in player.Backpack:GetChildren() do
		tool.Enabled = false
	end
	task.spawn(function()
		local first = true
		while true do
			task.wait(15)
			if character.Parent ~= workspace then break end
			if not character:HasTag("Downed") or character.Humanoid.Health <= 0 then break end
			character.Humanoid:TakeDamage(10)
			if first then
				first = false
				ReplicatedStorage.Communication.InfoCaller.Message:FireClient(Players:GetPlayerFromCharacter(character), "You take damage as you are down! Find someone to revive you!")
			end
		end		
	end)
	local player = Players:GetPlayerFromCharacter(character)
	local highlight = Highlight:Clone()
	highlight.Parent = character
	local prompt = Prompt:Clone()
	prompt.Parent = character.PrimaryPart
	ReplicatedStorage.Communication.Antagonist.Kill:FireClient(player, true, prompt)
	print("ARE WE GETTING HERE?")
	ReplicatedStorage.Communication.InfoCaller.Message:FireAllClients(`{player.Name} has been downed! Revive them!`)

	game.ReplicatedStorage.Communication.Shake.Create:FireClient(player, {
		ID = "Down",
		ShakeType = "Once",
		Preset = "Scare"
	})
	local connection 
	connection = prompt.Triggered:Connect(function(player)
		if player.Character:HasTag("Downed") then return end
		connection:Disconnect()
		DownService:Up(character)
	end)
	
	local finish = true
	for _, player in GameService.Alive do
		print("HELLO")
		if player.Character and not player.Character:HasTag("Downed") then
			print("CALLED?")
			finish = false
		end
	end
	print(finish)
	if finish then
		GameService:Finish()
	end
end

function DownService:Up(character)
	if not character:HasTag("Ignore") then return end
	character:RemoveTag("Ignore")
	character:RemoveTag("Downed")
	local prompt = character.PrimaryPart:FindFirstChild("RevivePrompt") 
	if prompt then
		prompt:Destroy()
	end
	local highlight = character:FindFirstChild("ReviveHighlight") 
	if highlight then
		highlight:Destroy()
	end
	local player = Players:GetPlayerFromCharacter(character)
	for _, tool: Tool in player.Backpack:GetChildren() do
		tool.Enabled = true
	end
	ReplicatedStorage.Communication.Antagonist.Kill:FireClient(player, false)
end

return DownService