--!strict
local DataStoreService = game:GetService("DataStoreService");
local Players = game:GetService("Players");

local GlobalLeaderboardClass = require(script.GlobalLeaderboardClass)

local mostTimeDS = DataStoreService:GetOrderedDataStore("mostTime", "DEV");
local mostFlipsDS = DataStoreService:GetOrderedDataStore("mostFlips", "DEV");

local flipsLeaderboardModel = workspace.GlobalLeaderboards.FlipsLeaderboard;
local minutesLeaderboardModel = workspace.GlobalLeaderboards.MinutesLeaderboard;

local template = script.template;

local WAIT_TIME = 120;

local GlobalLeaderboardService = {}

--[[
	Starts the core loop of reloading global leaderboards
	Sets up each page with every iteration
	Saves player's data after every reset, (autosave)
]]

function GlobalLeaderboardService.start()
	print("GlobalLeaderboardService Started")
	local flipsGL = GlobalLeaderboardClass.new(flipsLeaderboardModel, flipsLeaderboardModel.uiPart.flipsUi.container.scrollContainer, mostFlipsDS)
	local minutesGL = GlobalLeaderboardClass.new(minutesLeaderboardModel, minutesLeaderboardModel.uiPart.minutesUI.container.scrollContainer, mostTimeDS)
	task.spawn(function()
		while true do
			flipsGL:cleanUp()
			minutesGL:cleanUp()
			flipsGL:setUpPages()
			minutesGL:setUpPages()
			task.wait(WAIT_TIME)
			for _, player in Players:GetPlayers() do
				GlobalLeaderboardService.savePlayerOrderedDS(player)
			end
		end
	end)
end

--[[
	Saves player's data in each ordered datastore, minutes & flips
	@param player - The player whose data is being saved
]]

function GlobalLeaderboardService.savePlayerOrderedDS(player: Player)
	local key = player.UserId;
	local minutesVal: IntValue = player:FindFirstChild("leaderstats"):FindFirstChild("Minutes"):: IntValue;
	local flipsValue: IntValue = player:FindFirstChild("leaderstats"):FindFirstChild("Flips"):: IntValue;
	
	if minutesVal and flipsValue then
		local success, err = pcall(function()
			mostTimeDS:SetAsync(key, minutesVal.Value);
			mostFlipsDS:SetAsync(key, flipsValue.Value);
		end)

		if not success then
			warn(err);
		end
	else
		warn("Couldn't find minutesVal or flipsValue");
	end
end



return GlobalLeaderboardService
