--!strict

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TimeTrialFolder = workspace.TimeTrials
local TrialPortals = TimeTrialFolder:WaitForChild("TrialPortals")

local failPart = TimeTrialFolder.timeTrialFail
local resetPart = workspace.Portals.ObbyPortal2.portalExit

local timeTrialRE = ReplicatedStorage.Remotes.timeTrialRE

local TimeTrialService = {}
local currentPlayers: {[number] : boolean} = {} --table of player userds, current players doing time trial

local TAG = "trialPortal"

--[[
	Starts time trial service
	Sets up connections for failing and checking personal bests
	Connects portals 
]]

function TimeTrialService.start()
	for _, trialPortal: Model in ipairs(CollectionService:GetTagged(TAG)) do
		TimeTrialService._handlePortal(trialPortal)
	end
	
	--[[
		Resets player after failing
		@param otherPart - Part that touches fail part, checks if it is a player
	]]
	
	failPart.Touched:Connect(function(otherPart: BasePart)
		local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
		if player then
			TimeTrialService._resetPlayer(player)
			timeTrialRE:FireClient(player, "fail")
		end
	end)
	
	timeTrialRE.OnServerEvent:Connect(function(player, pb: number, pbVal: string)
		local personalBestVal = player:FindFirstChild("otherData"):FindFirstChild(pbVal):: NumberValue
		if personalBestVal then
			print(personalBestVal.Value)
			if pb < personalBestVal.Value then
				personalBestVal.Value = pb
			end
		end
	end)
	
	CollectionService:GetInstanceAddedSignal(TAG):Connect(TimeTrialService._handlePortal)
	
	print("TimeTrialService Started")
end

--[[
	Resets player if they fail, teleports them back to reset part
	@param player - The player who is being reset
]]

function TimeTrialService._resetPlayer(player: Player)
	assert(player.Character and player.Character.PrimaryPart)
	player.Character.PrimaryPart.CFrame = resetPart.CFrame + Vector3.new(0, 2, 0)
	if currentPlayers[player.UserId] then
		currentPlayers[player.UserId] = nil
	end
end

--[[
	Handles portal setup
		-Finds sensor part and checks if it is the start or end portal
		-Sets up touched connection for sensor and either starts or ends the run
	@param portal - The portal's model
]]

function TimeTrialService._handlePortal(portal: Model)
	local sensor = portal:FindFirstChild("sensor"):: BasePart
	local isStart = portal.Name:match("Start$")
	if sensor then
		sensor.Touched:Connect(function(otherPart)
			local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
			if player then	
				local personalBestValue = player:FindFirstChild("otherData"):FindFirstChild(portal:GetAttribute("pb")):: NumberValue
				if not isStart and currentPlayers[player.UserId] then
					TimeTrialService._resetPlayer(player)
					timeTrialRE:FireClient(player, "end", personalBestValue)
				elseif isStart and not currentPlayers[player.UserId] then
					currentPlayers[player.UserId] = true
					print(player.Name.." started ".. portal.Name)
					timeTrialRE:FireClient(player, "start", personalBestValue)
				end
			end
		end)
	end
end

return TimeTrialService
