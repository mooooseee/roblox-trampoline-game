--!strict
local DataStoreService = game:GetService("DataStoreService")
local mainDataStore = DataStoreService:GetDataStore("mainDataStore", "DEV") --leaderstats data store 
local keybindDataStore = DataStoreService:GetDataStore("keybindDataStore", "DEV")
local inventoryDataStore = DataStoreService:GetDataStore("inventoryDataStore", "DEV")
local otherDataStore = DataStoreService:GetDataStore("otherData", "DEV4")--points and personal best times

local PlayerDefaultData = require(script.PlayerDefaultData)

local prefix = "user_";

local PlayerDataService = {}

function PlayerDataService.GetData(player: Player) --get leaderstats data
	assert(player:IsA("Player"), "Invalid player argument")
	local key = prefix..player.UserId;
	local data: PlayerDefaultData.playerData;

	local success, err = pcall(function()
		data = mainDataStore:GetAsync(key);
	end)
	
	if not success then
		warn(err)
		data = PlayerDefaultData.defaultData;
	elseif not data then
		data = PlayerDefaultData.defaultData;
	end

	return data
end

function PlayerDataService.SaveData(player: Player) --save leaderstats data
	local key = prefix..player.UserId;
	local minutesValue: IntValue = player:FindFirstChild("leaderstats"):FindFirstChild("Minutes")::IntValue
	local flipsValue: IntValue = player:FindFirstChild("leaderstats"):FindFirstChild("Flips")::IntValue
	local data: PlayerDefaultData.playerData = {
		minutes = minutesValue.Value,
		flips = flipsValue.Value
	}
	local tries = 0;
	local MAX_TRIES = 5;
	
	local success, err
	repeat
		success, err = pcall(function()
			mainDataStore:SetAsync(key, data)
		end)
		tries += 1
	until success or tries == MAX_TRIES;
	
	if not success then 
		warn(err)
	end
end

function PlayerDataService.GetKeybinds(player: Player) --get keybinds
	local key = prefix..player.UserId
	local keybinds: PlayerDefaultData.playerKeybinds
	
	local success, err = pcall(function()
		keybinds = keybindDataStore:GetAsync(key)
	end)
	
	if not success then
		warn(err)
		keybinds = PlayerDefaultData.defaultKeybinds
	elseif not keybinds then
		keybinds = PlayerDefaultData.defaultKeybinds
	end
	
	return keybinds
end

function PlayerDataService.LoadInventory(player: Player)	
	local key = prefix..player.UserId
	local inventory: PlayerDefaultData.playerInventory
	
	local success, err = pcall(function()
		inventory = inventoryDataStore:GetAsync(key)
	end)
	
	if not success then
		warn(err)
		inventory = PlayerDefaultData.defaultInventory
	elseif not inventory then
		inventory = PlayerDefaultData.defaultInventory
	end
	
	return inventory
end

function PlayerDataService.SaveInventory(player: Player, inventory: PlayerDefaultData.playerInventory)
	local key = prefix..player.UserId
	local tries = 0;
	local MAX_TRIES = 5;

	local success, err
	repeat
		success, err = pcall(function()
			inventoryDataStore:SetAsync(key, inventory)
		end)
		tries += 1
	until success or tries == MAX_TRIES;

	if not success then
		warn(err)
	end
end

function PlayerDataService.LoadOtherData(player: Player)
	assert(player:IsA("Player"), "Invalid player argument")
	local key = prefix..player.UserId;
	local data: PlayerDefaultData.otherPlayerData;

	local success, err = pcall(function()
		data = otherDataStore:GetAsync(key);
	end)

	if not success then
		warn(err)
		data = PlayerDefaultData.defaultOtherData;
	elseif not data then
		data = PlayerDefaultData.defaultOtherData;
	end

	return data
end

function PlayerDataService.SaveOtherData(player: Player)
	local key = prefix..player.UserId;
	local pointsVal = player:FindFirstChild("otherData"):FindFirstChild("points"):: IntValue
	local personalBestEasyVal = player:FindFirstChild("otherData"):FindFirstChild("personalBestEasy"):: IntValue
	local personalBestHardVal = player:FindFirstChild("otherData"):FindFirstChild("personalBestHard"):: IntValue
	local data = {
		points = pointsVal.Value,
		personalBestEasy = personalBestEasyVal.Value,
		peronalBestHard = personalBestHardVal.Value
		
	}:: PlayerDefaultData.otherPlayerData
		
	local tries = 0;
	local MAX_TRIES = 5;

	local success, err
	repeat
		success, err = pcall(function()
			otherDataStore:SetAsync(key, data)
		end)
		tries += 1
	until success or tries == MAX_TRIES;

	if not success then 
		warn(err)
	end
end

return PlayerDataService