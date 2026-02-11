local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local Signal = require(ReplicatedStorage.Classes.Signal)

local Cutscenes = ReplicatedStorage.Cutscenes

local Cutscene = {}
Cutscene.__index = Cutscene

local function setUpConnections(self)
	self.Connections = {}
	self.Connections.Ended = self.MainTrack.Ended:Connect(function()
		self.Ended:Fire()
		self:Stop()
	end)
end

local function startCameraEngine(self)
	self.CameraEngine = coroutine.create(function()
		task.wait(0.1)
		while true do
			if self.Status ~= "Running" then break end
			Camera.CFrame = CFrame.new(self.AttachPart.Position, self.LookAtPart.Position)
			Camera.CameraType = Enum.CameraType.Scriptable


			local percentage = self.MainTrack.TimePosition/self.MainTrack.Length
			local frame = tostring(math.round(percentage*self.FOVFrames))
			local instance = self.Folder.Camera.FOV:FindFirstChild(frame)
			if instance then
				Camera.FieldOfView = instance.Value
			end
			RunService.RenderStepped:Wait()
		end
	end)
	coroutine.resume(self.CameraEngine)
end

local function stopCameraEngine(self)
	coroutine.close(self.CameraEngine)
end


function Cutscene.new(cutsceneName: string)
	local self = setmetatable({}, Cutscene)

	self.Folder = Cutscenes[cutsceneName]

	self.Rigs = {}
	self.Tracks = {}

	self.FOVFrames = #self.Folder.Camera.FOV:GetChildren()

	self.AttachPart = nil
	self.LookAtPart = nil

	self.MainTrack = nil

	self.Ended = Signal.new()

	self.State = "Normal" -- "Running, Suspended, Normal, Dead"

	for _, rig in self.Folder.Rigs:GetChildren() do
		local clone = rig:Clone()
		clone.Parent = workspace
		task.wait(0.1)
		table.insert(self.Rigs, clone)
	end

	for _, rig in self.Rigs do 
		local animator = rig:FindFirstChild("Animator", true)
		local track = animator:LoadAnimation(animator.Animation)
		if animator.Animation:HasTag("MainTrack") then
			self.MainTrack = track
		end
		self.Tracks[rig.Name] = track
		if rig:FindFirstChild("CameraPart") then
			self.AttachPart = rig.CameraPart
		end
		if rig:FindFirstChild("LookAtPart") then
			self.LookAtPart = rig.LookAtPart
		end
	end

	if not self.MainTrack then
		error(string.format("No MainTrack found for %s.", cutsceneName))
	end

	for _, track in self.Tracks do
		track:Play()
		track:AdjustSpeed(0)
		track.TimePosition = 0
		track.Looped = false
	end

	setUpConnections(self)

	return self
end

function Cutscene:Play()
	self.Status = "Running"
	for _, track in self.Tracks do
		task.spawn(function()
			track.TimePosition = track.Animation:GetAttribute("Offset") or 0
			track:AdjustSpeed(1)
		end)
	end
	startCameraEngine(self)
end

function Cutscene:Resume()
	self.Status = "Running"
	for _, track in self.Tracks do
		task.spawn(function()
			track:AdjustSpeed(1)			
		end)
	end
	startCameraEngine(self)
end

function Cutscene:Pause()
	stopCameraEngine(self)
	self.Status = "Suspended"
	for _, track in self.Tracks do
		task.spawn(function()
			track:AdjustSpeed(0)			
		end)
	end
end

function Cutscene:Stop()
	stopCameraEngine(self)
	self.Status = "Normal"
	for _, track in self.Tracks do
		task.spawn(function()
			track:Stop()			
		end)
	end
	Camera.CameraType = Enum.CameraType.Custom
end

function Cutscene:GetTrackByRigName(rigName: string)
	return self.Tracks[rigName]
end

function Cutscene:GetRigByRigName(rigName: string)
	for _, rig in self.Rigs do
		if rig.Name == rigName then
			return rig
		end
	end
end

function Cutscene:AdjustTimePosition(newTimePosition: number)
	for _, track in self.Tracks do
		track.TimePosition = newTimePosition
	end
end

function Cutscene:Destroy()
	self.Status = "Dead"
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	for _, rig in self.Rigs do
		rig:Destroy()
	end
end


local CutsceneService = {}

function CutsceneService:Create(cutsceneName: string)
	return Cutscene.new(cutsceneName)
end	



return CutsceneService