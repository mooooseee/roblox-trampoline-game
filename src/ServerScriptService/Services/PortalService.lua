--!strict
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local portalUiRE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("portalUiRE")

local PortalFolder = workspace.Portals

local PortalService = {}

--[[
	Starts portal service
	Handles the calling of the setup function for each portal and any new portal that is loaded late
]]

function PortalService.start()
	for _, portal in ipairs(PortalFolder:GetChildren()) do
		if portal:HasTag("portal") then
			PortalService._setupPortal(portal)
		end
	end
	
	CollectionService:GetInstanceAddedSignal("portal"):Connect(function(newPortal)
		PortalService._setupPortal(newPortal)
	end)
	
	print("PortalService Started")
end

--[[
	Handles each portal's setup
		-Finds the other side of the portal and its exist
		-Finds sensor of portal
		-Sets up touched connection for portal's sensor
		-Fires event to show UI transition
		-Teleports player's CFrame to other exit
	@param portal - The portal's model
]]

function PortalService._setupPortal(portal: Model)
	local otherPortal = PortalFolder:FindFirstChild(portal:GetAttribute("otherPortal"))
	local otherExit = otherPortal:FindFirstChild("portalExit"):: BasePart
	local sensor = portal:FindFirstChild("sensor"):: BasePart
	
	sensor.Touched:Connect(function(otherPart)
		local player = Players:GetPlayerFromCharacter(otherPart.Parent)
		if player and player.Character and otherExit then
			player.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			portalUiRE:FireClient(player)
			player.Character.PrimaryPart.Anchored = true
			task.wait(1.05)
			player.Character.PrimaryPart.CFrame = otherExit.CFrame
			portalUiRE:FireClient(player)
			task.wait(1.05) --time for close tween to play
			player.Character.PrimaryPart.Anchored = false
		end
	end)
end

return PortalService
