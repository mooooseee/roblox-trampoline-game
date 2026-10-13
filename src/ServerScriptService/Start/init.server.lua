--!strict
local Services = script.Parent.Services;

local Players = game:GetService("Players");

local CollisionService = require(Services.CollisionService);
local GlobalLeaderboardService = require(Services.GlobalLeaderboardService);
local PlayerDataService = require(Services.PlayerDataService);
local LeaderstatsService = require(Services.LeaderstatsService)
local KeybindService = require(Services.KeybindService)
local InventoryService = require(Services.InventoryService)
local OtherDataService = require(Services.OtherDataService)
local InventoryService = require(Services.InventoryService)
local ShopService = require(Services.ShopService)
local SwingService = require(Services.SwingService)

local Backend = require(script.Backend);
Backend.start();
ShopService.start();
SwingService.start();

local function onPlayerAdded(player: Player)
	--load leaderstats
	local data = PlayerDataService.GetData(player)
	LeaderstatsService.setupPlayer(player, data)
	
	--load other data
	local otherData = PlayerDataService.LoadOtherData(player)
	OtherDataService.newPlayer(player, otherData)
	
	InventoryService.newInv(player)
	
	KeybindService.setupKeybinds(player)
	CollisionService.newPlayer(player)
end

local function onPlayerRemoving(player: Player)
	GlobalLeaderboardService.savePlayerOrderedDS(player)
	PlayerDataService.SaveData(player)
	PlayerDataService.SaveOtherData(player)
	PlayerDataService.SaveInventory(player, InventoryService.getInv(player))
	LeaderstatsService.stopLoop(player)
	InventoryService.CleanUp(player)
end

for _, plr in ipairs(game.Players:GetPlayers()) do
	onPlayerAdded(plr)
end

Players.PlayerRemoving:Connect(onPlayerRemoving)
Players.PlayerAdded:Connect(onPlayerAdded)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		onPlayerRemoving(player)
	end
end)