--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local pointUpdateRE = Remotes:WaitForChild("pointUpdateRE")

local PlayerDataTypes = require(script.Parent.PlayerDataService.PlayerDefaultData)
type otherDataType = PlayerDataTypes.otherPlayerData

local OtherDataService = {}

function OtherDataService.newPlayer(player: Player, data: otherDataType)
	assert(player:IsA("Player"),"Invalid player argument.")
	local otherData = Instance.new("Folder")
	otherData.Name = "otherData"
	otherData.Parent = player
	
	local pointsVal = Instance.new("IntValue")
	pointsVal.Value = data.points
	pointsVal.Name = "points"
	pointsVal.Parent = otherData
	
	local pbEVal = Instance.new("NumberValue")
	pbEVal.Value = data.personalBestEasy
	pbEVal.Name = "personalBestEasy"
	pbEVal.Parent = otherData
	
	local pbHVal = Instance.new("NumberValue")
	pbHVal.Value = data.peronalBestHard
	pbHVal.Name = "personalBestHard"
	pbHVal.Parent = otherData
	
	if pbEVal.Value == 0 then
		pbEVal.Value = math.huge
	end
	
	if pbHVal.Value == 0 then
		pbHVal.Value = math.huge
	end
	
	pointUpdateRE:FireClient(player, pointsVal.Value)
	
	pointsVal.Changed:Connect(function(newValue)
		pointUpdateRE:FireClient(player, newValue)
	end)
end

return OtherDataService
