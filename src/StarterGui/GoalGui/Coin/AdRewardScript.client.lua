local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local button = script.Parent
local rewardEvent = ReplicatedStorage.Communication.Ads.Reward

local INELIGIBLE_RESULTS = {
	Enum.AdAvailabilityResult.PlayerIneligible,
	Enum.AdAvailabilityResult.DeviceIneligible,
	Enum.AdAvailabilityResult.PublisherIneligible,
	Enum.AdAvailabilityResult.ExperienceIneligible,
}

-- Check if result is an ineligible result (permanently can't show ads)
local function isIneligible(result)
	for _, ineligibleResult in ipairs(INELIGIBLE_RESULTS) do
		if result == ineligibleResult then
			return true
		end
	end
	return false
end

-- Check if ads are available and update button visibility
local function checkForAds()
	local isSuccess, result = pcall(function()
		return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo)
	end)
	
	if isSuccess and result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable then
		button.Visible = true
		return
	end
	
	-- If player is permanently ineligible, keep button hidden
	if isSuccess and isIneligible(result.AdAvailabilityResult) then
		button.Visible = false
		return
	end
	
end

-- Listen for server response after ad is shown
rewardEvent.OnClientEvent:Connect(function(isSuccess, result)
	if isSuccess and result == Enum.ShowAdResult.ShowCompleted then
		print("Ad completed successfully!")
		checkForAds()
	elseif result == Enum.ShowAdResult.ShowInterrupted then
		print("Ad was abandoned")
		checkForAds()
	else
		warn("Ad show failed:", result)
		checkForAds()
	end
end)

-- Button click handler - fire to server to show ad
button.Activated:Connect(function()

	rewardEvent:FireServer()
end)

---- Initial check when script loads
--task.spawn(function()
--	-- Wait a moment for AdService to initialize
--	task.wait(1)
--	checkForAds()
	
--	-- Periodically check availability (every 30 seconds)
--	while task.wait(30) do
--		checkForAds()
--	end
--end)
