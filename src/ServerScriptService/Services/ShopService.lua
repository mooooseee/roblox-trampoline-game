--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local buyFlipRE = Remotes:WaitForChild("buyFlipRE")
local getOwnedFlipsRF = Remotes:WaitForChild("getOwnedFlipsRF")

local InventoryService = require(ServerScriptService.Services.InventoryService)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local TrickService = require(ServerScriptService.Services.TrickService)
local Images = require(ServerScriptService.Services.InventoryService.Images)
local FlipShopConfig = require(ReplicatedStorage.Shared.FlipShopConfig)

local ShopService = {}

-- Build price lookup from the shared config
local priceByName = {}
for _, item in ipairs(FlipShopConfig) do
	priceByName[item.name] = item.price
end

function ShopService.start()
	-- Client asks which flips it already owns (used by the shop AND the inventory UI)
	getOwnedFlipsRF.OnServerInvoke = function(player: Player)
		local inv = InventoryService.getInv(player)
		if not inv then return {} end
		local owned = {}
		for trickName in pairs(inv) do
			table.insert(owned, {name = trickName, image = Images[trickName]})
		end
		return owned
	end

	buyFlipRE.OnServerEvent:Connect(function(player: Player, trickName: unknown)
		local function respond(success: boolean, message: string)
			buyFlipRE:FireClient(player, trickName, success, message)
		end

		-- Validate the request
		if typeof(trickName) ~= "string" then return end
		local trickInfo = TrickService.tricks[trickName]
		local price = priceByName[trickName]
		if not trickInfo or price == nil then
			return respond(false, "Not available")
		end

		local inv = InventoryService.getInv(player)
		if not inv then
			return respond(false, "Try again")
		end
		if inv[trickName] then
			return respond(false, "Already owned")
		end

		-- Check & deduct points (points IntValue change auto-fires pointUpdateRE to the client)
		local otherData = player:FindFirstChild("otherData")
		local pointsVal = otherData and otherData:FindFirstChild("points")
		if not pointsVal or not pointsVal:IsA("IntValue") then
			return respond(false, "Try again")
		end

		if pointsVal.Value < price then
			return respond(false, "Not enough points")
		end

		pointsVal.Value -= price
		InventoryService.addTrick(player, trickName, trickInfo)
		PlayerDataService.SaveInventory(player, InventoryService.getInv(player))

		print(player.Name .. " purchased " .. trickName .. " for " .. price .. " points")
		respond(true, "Purchased!")
	end)

	print("ShopService Started")
end

return ShopService