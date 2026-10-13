--!strict
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FoamFolder = workspace["Foam Balls"]
local respawnPoint = FoamFolder.RespawnPoint -- point for player to respawn to

local FoamService = {}

--[[
	Starts foam service
	Handles the calling of the setup function for each foam block and any new foam block that is loaded late
]]

function FoamService.start()
	for _, foam in ipairs(CollectionService:GetTagged("foam")) do
		FoamService._setupFoam(foam)
	end
	
	CollectionService:GetInstanceAddedSignal("foam"):Connect(function(newFoam)
		FoamService._setupFoam(newFoam)
	end)
	
	print("PortalService Started")
end

--[[
	Handle's setup of foam block
		-Teleports player back to designated foam reset point
]]

function FoamService._setupFoam(foam: Part)
	foam.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player and player.Character and not FoamService[player.UserId] then
			FoamService[player.UserId] = true -- debounce
			player.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			player.Character.PrimaryPart.Anchored = true
			player.Character.PrimaryPart.CFrame = respawnPoint.CFrame
			player.Character.PrimaryPart.Anchored = false
			FoamService[player.UserId] = nil -- debounce
		end
	end)
end

return FoamService
