local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local TweenService = require(script.Parent.Services.TweenService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local SurpriseService = require(ServerStorage.Services.SurpriseService)
local DownService = require(ServerStorage.Services.DownService)
local AudioService = require(ReplicatedStorage.Services.AudioService)

local functions = require(ReplicatedStorage.Modules.functions)

local Signal = require(script.Parent.Classes.Signal)
local Sight = require(script.Parent.Classes.Sight)
local Visual = require(ServerStorage.Classes.Visual)


local Antagonist = {}
Antagonist.__index = Antagonist

local TestPoints = CollectionService:GetTagged("Chat")
for i, point in TestPoints do
	TestPoints[i] = point.Position
end

--[[
States:
Idle --doesn't see a player and j chillin
Spot --just spotted a player
Chase --chasing a player and can see player
Halt --recently lost sight so slowing down
Kill --actively killing a player cuz they caught them
Dead --not active
]]

local StatePriorities = {
	Idle = 1,
	Spot = 2,
	Chase = 1,
	Halt = 1,
	Trap = 3,
	Hit = 3,
	Surprise = 3,
	Emergency = 1
}

local walkDistance = function(waypoints: {PathWaypoint})
	local distance = 0
	for i = 1, #waypoints - 1 do
		distance += (waypoints[i].Position - waypoints[i+1].Position).Magnitude
	end
	return distance
end

local displayPoints = function(points: {PathWaypoint})
	local parts = {}
	for _, point in points do
		local part = Instance.new("Part", workspace)
		part.Size = Vector3.new(1,1,1)
		part.Position = point.Position
		part.Anchored = true
		part.Material = Enum.Material.Neon
		part.CanCollide = false
		part.Transparency = 1
		table.insert(parts, part)
	end
	return parts
end

local function stopAllAnims(animator: Animator)
	for _, track in animator:GetPlayingAnimationTracks() do
		track:Stop()
	end
end

local function touched(self, hit)
	if Players:GetPlayerFromCharacter(hit.Parent) and StatePriorities[self.State] <= 2 and not hit.Parent:HasTag("Ignore") and self.KillCooling == false then
		--[[
		self.KillCooling = true
		self.KillTrack:Play()
		self.KillTrack:AdjustSpeed(2)
		self.KillTrack.Looped = false
		--for funsies testing
		--hit.Parent:AddTag("Ignore")
		task.wait(self.KillCooldown)
		self.KillCooling = false]]
	elseif hit.Parent and hit.Parent.Name == "Trap" and hit.Parent:GetAttribute("Closed") == false then
		local activated = hit.Parent:FindFirstChild("Activated")
		if not activated then return end
		activated:Fire()
		self:SetState("Trap")
	elseif hit:HasTag("Door") then
		self:Duck()
	end	
end

local function notLooking(self)
	self.NotLookingEngine = coroutine.create(function()
		if self.Antagonist:HasTag("SkipFirst") then
			self.Antagonist:RemoveTag("SkipFirst")
		else
			local amount = functions.surprise()
			task.wait(amount) --amount idk
		end
		
		SurpriseService:Add(self)
	end)
	coroutine.resume(self.NotLookingEngine)
end

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Touched = self.Antagonist:FindFirstChild("Hitbox").Touched:Connect(function(hit)
		touched(self, hit)
	end)
	self.Connections.Hit = ReplicatedStorage.Communication.Ball.Hit.OnServerEvent:Connect(function(player, antagonist)
		if antagonist ~= self.Antagonist then return end
		self:SetState("Hit")
	end)
	self.Connections.VisualChanged = self.Visual.Changed:Connect(function(looking)
		if looking then
			if self.NotLookingEngine then
				SurpriseService:Remove(self)
				coroutine.close(self.NotLookingEngine)
			end
		else
			notLooking(self)
		end
	end)
	self.Connections.Kill = ReplicatedStorage.Communication.Antagonist.Kill.OnServerEvent:Connect(function(player, antagonist)
		if antagonist ~= self.Antagonist then return end
		if player.Character == nil then return end
		if StatePriorities[self.State] <= 2 and not player.Character:HasTag("Ignore") and self.KillCooling == false then
			self.KillCooling = true
			self.KillTrack:Play()
			self.KillTrack:AdjustSpeed(2)
			self.KillTrack.Looped = false
			DownService:Down(player.Character)
			
			task.wait(self.KillCooldown)
			self.KillCooling = false
		end
	end)
	self.Connections.Destroying = self.Antagonist.Destroying:Connect(function()
		if self.StateEngine then
			coroutine.close(self.StateEngine)
		end
		if self.NotLookingEngine then
			coroutine.close(self.NotLookingEngine)
		end
		if self.PathEngine then
			coroutine.close(self.PathEngine)
		end
		if self.EvaluationEngine then
			coroutine.close(self.EvaluationEngine)
		end
	end)
end


function Antagonist.new(antagonist: Model)
	local self = setmetatable({}, Antagonist)
	
	self.Antagonist = antagonist
	self.State = "Dead"	
	self.Sight = Sight.new({
		Head = antagonist:WaitForChild("HumanoidRootPart"),
		Antagonist = antagonist,
		FOV = 360,
		Distance = 70
	})
	
	self.WalkingSound = script.Parent.Sounds.WalkingFootsteps:Clone()
	self.WalkingSound.Parent = self.Antagonist.PrimaryPart
	self.RunningSound = script.Parent.Sounds.RunningFootsteps:Clone()
	self.RunningSound.Parent = self.Antagonist.PrimaryPart
	
	self.Visual = Visual.new(self.Antagonist)
	
	self.TrackDelay = 0.5
	
	self.Humanoid = antagonist.Humanoid
	self.Animator = self.Humanoid.Animator
	
	self.WalkTrack = self.Animator:LoadAnimation(antagonist.Animations.Walk)
	self.ChaseTrack = self.Animator:LoadAnimation(antagonist.Animations.Chase)
	--self.IdleTrack = self.Animator:LoadAnimation(antagonist.Animations.Idle)
	self.TrapTrack = self.Animator:LoadAnimation(antagonist.Animations.Trap)
	self.HitTrack = self.Animator:LoadAnimation(antagonist.Animations.Hit)
	self.SpotTrack = self.Animator:LoadAnimation(antagonist.Animations.Spot)
	self.KillTrack = self.Animator:LoadAnimation(antagonist.Animations.Kill)
	self.DuckTrack = self.Animator:LoadAnimation(antagonist.Animations.Duck)
	
	self.SurpriseTracks = {}
	for _, animation in antagonist.Animations.Surprises:GetChildren() do
		self.SurpriseTracks[animation.Name] = self.Animator:LoadAnimation(animation)
	end
	
	self.WalkTrack.Priority = Enum.AnimationPriority.Action
	self.DuckTrack.Priority = Enum.AnimationPriority.Action2
	
	self.KillCooling = false
	self.KillCooldown = 1
	
	self.Ducking = false

	
	self.Path = PathfindingService:CreatePath({
		AgentCanJump = false,
		AgentRadius = 3,
		AgentHeight = 9,
		WaypointSpacing = 8,
		AgentCanClimb = false,
		Costs = {
		}
	})
	
	self.CurrentTrack = nil
	
	setUpConnections(self)
	notLooking(self)
	
	return self
end

function Antagonist:Idle()
	self.StateEngine = coroutine.create(function()
		print("idling")
		
		if self.CurrentTrack then
			self.CurrentTrack:Stop(self.TrackDelay)
		end

		self.CurrentTrack = self.WalkTrack
		self.CurrentTrack:Play(self.TrackDelay)
		
		self.Humanoid.WalkSpeed = self.Antagonist:GetAttribute("NormalWalkSpeed")
		
		local lastRandomPoint = nil
		while true do
			local randomPoints = table.clone(TestPoints)
			local i = table.find(randomPoints, lastRandomPoint)
			if i then
				table.remove(randomPoints, i)
			end
			repeat
				if #randomPoints == 0 then
					--print("calling emergency")
					self:SetState("Emergency")
					return
				end
				local randomPoint = table.remove(randomPoints, math.random(1, #randomPoints))
				self.Path:ComputeAsync(self.Antagonist:GetPivot().Position, randomPoint)
				lastRandomPoint = randomPoint
			until self.Path.Status == Enum.PathStatus.Success
			
			local finished = self:WalkPath(self.Path:GetWaypoints())
			finished:Wait()
		end
	end)

	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end

function Antagonist:Spot(metadata: {
		Character: Model
	})

	self.StateEngine = coroutine.create(function()
		print("spotting")
		
		AudioService:Add3D("Shock", self.Antagonist.PrimaryPart, false, "Shock", 0.4)
		
		if self.Ducking then
			
			metadata.FromSpot = true
			self:SetState("Chase", metadata)
			return
		end
		if self.CurrentTrack then
			self.CurrentTrack:Stop(0.5)
		end
		self:StopPath()
		self.Humanoid:MoveTo(self.Antagonist:GetPivot().Position)
		self.CurrentTrack = self.SpotTrack
		--self.Antagonist.PrimaryPart.Anchored = true
		local lookAt do 
			lookAt = metadata.Character:GetPivot().Position
			lookAt = Vector3.new(lookAt.X, self.Antagonist:GetPivot().Position.Y, lookAt.Z)
		end
		TweenService:CreateMethodTween(
			self.Antagonist,
			TweenInfo.new(self.CurrentTrack.Length, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			"PivotTo",
			self.Antagonist:GetPivot(),
			CFrame.new(self.Antagonist:GetPivot().Position, lookAt)
		):Play()
		
		self.CurrentTrack:Play(0.5)
		self.CurrentTrack.Looped = false
		self.CurrentTrack.Ended:Wait()
		--self.Antagonist.PrimaryPart.Anchored = false
		if StatePriorities[self.State] > StatePriorities["Spot"] then
			return
		end
		if metadata.Character:HasTag("Ignore") then
			self:SetState("Idle")
		else
			metadata.FromSpot = true
			self:SetState("Chase", metadata)			
		end
	end)
	

	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end

function Antagonist:Chase(metadata: {
		Character: Model,
		FromSpot: boolean?
	})
	print("chasing")
	if metadata.FromSpot then
		self.FromSpot = true
	else
		self.FromSpot = false
	end
	self.StateEngine = coroutine.create(function()
		if self.ChaseTween then
			self.ChaseTween:Cancel()
			self.ChaseTween:Destroy()
		end
		
		if self.ChaseTween2 then
			self.ChaseTween2:Cancel()
			self.ChaseTween2:Destroy()
		end
		
		if self.ChaseTween3 then
			self.ChaseTween3:Cancel()
			self.ChaseTween3:Destroy()
		end
		
		self.RunningSound.PlaybackSpeed = 1.4
		self.RunningSound:Play()
		
		if self.CurrentTrack then
			self.CurrentTrack:Stop()
		end
		
		self.CurrentTrack = self.ChaseTrack
		self.CurrentTrack:Play()
		task.spawn(function()
			task.wait(0.1)
			self.CurrentTrack:AdjustSpeed(1)			
		end)
		
		self.Humanoid.WalkSpeed = self.Antagonist:GetAttribute("ChaseWalkSpeed")
		self.Humanoid:MoveTo(metadata.Character:GetPivot().Position)	
		local testPart = nil
		while true do
			self.Path:ComputeAsync(self.Antagonist:GetPivot().Position, metadata.Character:GetPivot().Position)
			local calculatedDistance = walkDistance(self.Path:GetWaypoints())
			local waypoints = self.Path:GetWaypoints()
			
			
			local hasDoor = false
			for _, point in waypoints do
				if point.Label == "Door" then 
					print("HAS DOOR")
					hasDoor = true
				end
			end
			--[[
			check to see if at door
			]]
			local threshold = 3
			for i = 1, 3 do
				local point = waypoints[i] 
				if not point then break end
				if point.Label == "Door" then
					for j = 1, i - 1 do
						table.remove(waypoints, 1)
					end
					break
				end
			end
			
			local directDistance = (metadata.Character:GetPivot().Position - self.Antagonist:GetPivot().Position).Magnitude
			if (calculatedDistance > 1.15 * directDistance or calculatedDistance < 10 or self.Path.Status == Enum.PathStatus.NoPath) and self.Sight.Spotted ~= nil and not hasDoor then
				local velocity = metadata.Character.PrimaryPart.AssemblyLinearVelocity
				local magnitude = velocity.Magnitude
				local offset: Vector3 = nil
				if magnitude <= 0.2 then
					offset = Vector3.zero
				else
					offset = velocity/3
				end
				
				--print("moveto")
				self.Humanoid:MoveTo(metadata.Character:GetPivot().Position + offset)
			else
				self:WalkPath(waypoints)	
			end
		end
	end)

	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end

function Antagonist:Halt(metadata: {
		Character: Model
	})
	self.StateEngine = coroutine.create(function()
		print("halting")
		
		--task.wait(1)
		
		local function halt()
			local lastWaypoints = self.Path:GetWaypoints()
			self.Path:ComputeAsync(self.Antagonist:GetPivot().Position, metadata.Character:GetPivot().Position)
			local waypoints = self.Path:GetWaypoints()
			self:WalkPath(waypoints)
			--print("last waypoints", lastWaypoints)

			local distance = math.clamp(walkDistance(waypoints), 0, 50)
			local avgWalkSpeed = self.Humanoid.WalkSpeed/2
			local t = distance/avgWalkSpeed
			t *= 1

			if self.CurrentTrack == self.ChaseTrack then
				self.CurrentTrack:AdjustSpeed(1)
				self.ChaseTween = TweenService:CreateMethodTween(
					self.CurrentTrack,
					TweenInfo.new(t, Enum.EasingStyle.Linear),
					"AdjustSpeed",
					1,
					0
				)

				self.ChaseTween2 = TweenService:Create(
					self.Humanoid,
					TweenInfo.new(t, Enum.EasingStyle.Linear),
					{
						WalkSpeed = 0
					}
				)
				
				self.ChaseTween3 = TweenService:Create(
					self.RunningSound,
					TweenInfo.new(t, Enum.EasingStyle.Linear),
					{
						PlaybackSpeed = 0
					}
				)
				
				self.ChaseTween:Play()
				self.ChaseTween2:Play()
				self.ChaseTween3:Play()

				self.ChaseTween2.Completed:Wait()
			end
			self:SetState("Idle")
		end	
		halt()
	end)
	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end

function Antagonist:Emergency(metadata: {})
	print("emergency")
	self.StateEngine = coroutine.create(function()
		while true do
			task.wait(0.1)
			local randomPoint = self.Antagonist.PrimaryPart.Position + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
			local pathData = {
				PathWaypoint.new(self.Antagonist.PrimaryPart.Position, Enum.PathWaypointAction.Walk, "Start"),
				PathWaypoint.new(randomPoint, Enum.PathWaypointAction.Walk, "End")
			}
			local signal = self:WalkPath(pathData)
			signal:Wait()
		end
		
		end)
		local ok, err = coroutine.resume(self.StateEngine)
		if err then print(err, debug.traceback()) end
end

function Antagonist:Trap(metadata: {})
	self:PauseState(self.TrapTrack)
end

function Antagonist:Hit(metadata: {})
	self:PauseState(self.HitTrack)
end

function Antagonist:PauseState(track: AnimationTrack)
	self.StateEngine = coroutine.create(function()
		if self.CurrentTrack then
			self.CurrentTrack:Stop(self.TrackDelay)
		end
		self:StopPath()
		self.Humanoid:MoveTo(self.Antagonist:GetPivot().Position)
		self.CurrentTrack = track
		self.CurrentTrack:Play(self.TrackDelay)
		self.CurrentTrack.Looped = false
		self.CurrentTrack.Ended:Wait()
		self:SetState("Idle")
	end)
	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end

function Antagonist:Surprise(metadata: {SurpriseBlock: Part, Player: Player})
	self.StateEngine = coroutine.create(function()
		--[[
		if metadata.SurpriseBlock:GetAttribute("Using") then return end
		metadata.SurpriseBlock:SetAttribute("Using", true)]]
		print("---")
		local surpriseFolder = metadata.SurpriseBlock.Parent
		print(surpriseFolder)
		print(metadata.SurpriseBlock)
		local teleportBlock = surpriseFolder.TeleportBlocks[self.Antagonist.Name]
		print(teleportBlock)
		local main = require(surpriseFolder.Main)
		if self.CurrentTrack then
			self.CurrentTrack:Stop(self.TrackDelay)
		end
		self:StopPath()
		
		self.CurrentTrack = self.SurpriseTracks[surpriseFolder:GetAttribute("Type")]
		self.Antagonist.PrimaryPart.Anchored = true
		task.spawn(function()
			main(metadata.Player)
		end)
		self.CurrentTrack:Play()
		self.CurrentTrack.Looped = false
		self.CurrentTrack:GetMarkerReachedSignal("Start"):Wait()
		self.CurrentTrack:AdjustSpeed(0)
		self.Antagonist:PivotTo(teleportBlock.CFrame)
		task.wait(0.5)
		self.CurrentTrack:AdjustSpeed(1)
		self.CurrentTrack:GetMarkerReachedSignal("End"):Wait()
		self.CurrentTrack:Stop(0.5)
		self.Antagonist.PrimaryPart.Anchored = false
		
		self.CurrentTrack = self.ChaseTrack
		self.CurrentTrack:Play(0.5)
		metadata.SurpriseBlock:SetAttribute("Using", "")
		if metadata.Player.Character then
			self:SetState("Chase", {
				Character = metadata.Player.Character,
				FromSpot = true
			})
		else
			self:SetState("Idle")
		end
	end)
	
	local ok, err = coroutine.resume(self.StateEngine)
	if err then print(err, debug.traceback()) end
end
	
function Antagonist:SetState(state: string, metatadata: {}, machine: boolean)
	print(state)
	if machine and StatePriorities[state] < StatePriorities[self.State] then return end
	if self.Antagonist.PrimaryPart == nil then return end
	if state == "Idle" then
		self.WalkingSound:Play()
		self.RunningSound:Stop()
	elseif state == "Chase" then
		self.WalkingSound:Stop()
	elseif state == "Halt" then
		self.WalkingSound:Stop()
	else
		self.WalkingSound:Stop()
		self.RunningSound:Stop()
	end
	
	self.Antagonist.PrimaryPart:SetNetworkOwner()	
	if self.StateEngine ~= nil then
		pcall(function()
			coroutine.close(self.StateEngine)	
		end)
	end
	self.State = state
	self[state](self, metatadata)
end

function Antagonist:EvaluateStateMachine()
	self.EvaluationEngine = coroutine.create(function()
		local lastSpotted = self.Sight.Spotted
		while true do
			if self.Sight.Spotted ~= lastSpotted then
				if self.Sight.Spotted ~= nil then
					if self.State == "Idle" then
						self:SetState("Spot", {
							Character = self.Sight.Spotted
						}, true)
					else
						self:SetState("Chase", {
							Character = self.Sight.Spotted
						}, true)
					end
				else
					self:SetState("Halt", {
						Character = lastSpotted
					}, true)
				end
				lastSpotted = self.Sight.Spotted
			elseif self.State == "Idle" and self.Sight.Spotted ~= nil then
				self:SetState("Spot", {
					Character = self.Sight.Spotted
				}, true)
				lastSpotted = self.Sight.Spotted
			elseif (self.State == "Chase" and self.Sight.Spotted == nil and self.FromSpot ~= true) or (self.State == "Chase" and self.Sight.Spotted == nil and self.FromSpot == true)   then
				self:SetState("Idle")
			end
			if self.State == "Emergency" then
				if self.Sight.Spotted then
					self:SetState("Spot", {
						Character = self.Sight.Spotted
					}, true)
				end
				local point = table.clone(TestPoints)[1]
				self.Path:ComputeAsync(self.Antagonist:GetPivot().Position, point)
				if self.Path.Status == Enum.PathStatus.Success then
					self:SetState("Idle", {}, true)
				end
			end
			RunService.Heartbeat:Wait()
			--[[
			local lastSpotted = self.Sight.Spotted
			local spotted = self.Sight.Changed:Wait()
			if spotted ~= nil then
				self:SetState("Spot", {
					Character = spotted
				})
			else
				self:SetState("Halt", {
					Character = lastSpotted
				})
			end]]
		end
	end)
	local ok, err = coroutine.resume(self.EvaluationEngine)
	if err then print(err, debug.traceback()) end 
end

function Antagonist:WalkPath(points: {PathWaypoint})
	if self.PathEngine then
		coroutine.close(self.PathEngine)
	end
	if self.DisplayPoints then
		for _, part in self.DisplayPoints do
			part:Destroy()
		end
	end
	self.DisplayPoints = displayPoints(points)
	self.LastPoints = table.clone(points)
	local finished = Signal.new()
	self.PathEngine = coroutine.create(function()
		for i, point in points do
			if i == 1 and point.Label ~= "Door" then continue end
			--print(point.Label)
			if point.Label == "Door" then
				spawn(function()
					self:Duck()
				end)
			end
	
			self.Humanoid:MoveTo(point.Position)
			local finished2 = Signal.new()
			local a = coroutine.create(function()
				self.Humanoid.MoveToFinished:Wait()
				finished2:Fire("a")
			end)
			local b = coroutine.create(function()
				task.wait(2)
				finished2:Fire("b")
			end)
			coroutine.resume(b)
			coroutine.resume(a)
			local option = finished2:Wait()
			if option == "b" then
				print("got stuck during idle", self.Antagonist:GetPivot().Position)
				break
			end
		end
		finished:Fire()
	end)
	local ok, err = coroutine.resume(self.PathEngine)
	if err then print(err, debug.traceback()) end
	return finished
end

function Antagonist:Duck()
	local walkSpeed = self.Humanoid.WalkSpeed
	
	local t = (walkSpeed - 28)/-40
	local t2 = (walkSpeed - 28)/-16
	self.Ducking = true
	self.DuckTrack:Play(t)
	task.wait(t2)
	self.DuckTrack:Stop(t)
	self.Ducking = false
end

function Antagonist:StopPath()
	if self.PathEngine then
		coroutine.close(self.PathEngine)
	end
end

function Antagonist:Start()
	self:SetState("Idle")
	self:EvaluateStateMachine()
end

return Antagonist