local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)
local TweenService = game:GetService("TweenService")

local table = require(ReplicatedStorage.Libraries.table)

local AudioSettings = require(ReplicatedStorage.Settings.AudioSettings)

local Sounds = workspace.Sounds

local AudioService = {}

function AudioService:Add(id: string, soundType: string, looped: boolean, preset: string, startTime: number)
	local sound: Sound = AudioSettings.Presets[preset]:Clone()
	sound:AddTag(AudioSettings.SoundTag)
	sound.Parent = Sounds[soundType]
	sound.SoundGroup = sound.Parent
	sound.TimePosition = startTime or 0
	sound:SetAttribute("ID", id)
	sound:Play()
	sound.Looped = looped
	task.spawn(function()
		if not looped then
			sound.Ended:Wait()
			sound:Destroy()
		end
	end)
	return sound
end

function AudioService:Add3D(id: string, instance: Instance, looped: boolean, preset: string, startTime: number)
	local sound: Sound = AudioSettings.Presets[preset]:Clone()
	sound:AddTag(AudioSettings.SoundTag)
	sound.Parent = instance
	sound.TimePosition = startTime or 0
	sound:SetAttribute("ID", id)
	sound.Looped = looped
	sound:Play()
	task.spawn(function()
		if not looped then
			sound.Ended:Wait()
			sound:Destroy()
		end
	end)
	return sound
end

function AudioService:Remove(id: string, fade: boolean, n: number)
	task.spawn(function()
		local sounds = TagService:GetTagged(AudioSettings.SoundTag)
		sounds = table.filter(sounds, function(sound)
			return sound:GetAttribute("ID") == id
		end)
		local sound = sounds[1]
		if sound then
			if fade then
				local tween = TweenService:Create(
					sound,
					TweenInfo.new(n, Enum.EasingStyle.Linear),
					{
						Volume = 0
					}
				)
				tween:Play()
				tween.Completed:Wait()
			end
			sound:Destroy()
		end
	end)

end

function AudioService:AdjustSoundGroupVolume(name: string, n: number)
	Sounds[name].Volume = n
end

return AudioService