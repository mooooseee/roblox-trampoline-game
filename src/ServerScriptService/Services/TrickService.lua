--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local updateFlipRE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("updateFlipRE")
local InventoryService = require(game:GetService("ServerScriptService").Services.InventoryService)

--type
local TrickController = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Services"):WaitForChild("TrickController"))
type TrickClass = TrickController.TrickClass

local TrickService = {}

TrickService.tricks = {
	["Backflip"] = {id = "rbxassetid://16250918536", minHeight = 27, points = 1},
	["Frontflip"] = {id = "rbxassetid://16370738943", minHeight = 27, points = 1},
	["Sky Backflip"] = {id = "rbxassetid://16250918536", minHeight = 40, points = 2},
	["Sky Frontflip"] = {id = "rbxassetid://16370738943", minHeight = 40, points = 2}
}

--[[
	Starts the service's listener & creates remote function 
]]

function TrickService.start() 
	TrickService._listenForUpdate()
	local re = Instance.new("RemoteFunction")
	re.Parent = ReplicatedStorage
	print("TrickService Started")
end

--[[
	Gets info of a flip via name
	@param flipName - The flip's name as a string, used as key for tricks array
]]

function TrickService.getInfoFromFlip(flipName: string)
	return TrickService.tricks[flipName]
end

--[[
	Checks if flip is valid by checking the state of player and if the player has the flip in their inventory
	@param player - Player who is attempting to flip
	@param flipName - The flip the player is trying to perform
	Uses inventory service to check if flip is in player's inventory
]]

function TrickService._checkValidFlip(player: Player, flipName: string)
	assert(player.Character and player.Character.PrimaryPart)
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	
	local inv = InventoryService.getInv(player)
	if inv[flipName] == nil then return false end
	
	if humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then return false end
	
	-- Server-side raycast to verify player is above a trampoline
	local trickInfo = TrickService.tricks[flipName]
	local minHeight = trickInfo and trickInfo.minHeight or 27
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {player.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local rayOrigin = player.Character.PrimaryPart.Position
	local rayResult = workspace:Raycast(rayOrigin, Vector3.new(0, -100, 0), rayParams)
	
	if rayResult and rayResult.Instance.Name == "tramp" and (rayOrigin.Y - rayResult.Position.Y) >= minHeight then
		return true
	end
	return false
end

--[[
	Used to update player's flip count + point count after a successful flip
	Updates each intvalue specifically
	Increments flip by 1
	Adds correct # of points by obtaing flip information
]]

function TrickService._listenForUpdate()
	updateFlipRE.OnServerEvent:Connect(function(player: Player, trickName: string)
		print("received on server")
		local trickInfo = TrickService.tricks[trickName]
		assert(type(trickInfo.points) == "number" and trickInfo.points > 0)
		if TrickService._checkValidFlip(player, trickName) then
			local flipsValue = player:FindFirstChild("leaderstats"):FindFirstChild("Flips")::IntValue
			flipsValue.Value += 1
			local pointsValue = player:FindFirstChild("otherData"):FindFirstChild("points")::IntValue
			pointsValue.Value += trickInfo.points
		end
	end)
end


return TrickService
