--!strict
local PlayerDefaultData = require(script.Parent.PlayerDataService.PlayerDefaultData)

local LeaderstatsService = {}
local loopThreads = {} :: {[number]: thread}

function LeaderstatsService.setupPlayer(player: Player, data: PlayerDefaultData.playerData)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local minutesValue = Instance.new("IntValue")
	minutesValue.Name = "Minutes"
	minutesValue.Parent = leaderstats
	minutesValue.Value = data.minutes
	
	local flipsValue = Instance.new("IntValue")
	flipsValue.Name = "Flips"
	flipsValue.Parent = leaderstats
	flipsValue.Value = data.flips
	
	LeaderstatsService._startMinuteLoop(player, minutesValue)
	
	print("LeaderstatsService loaded for "..player.UserId)
end

function LeaderstatsService.stopLoop(player: Player)
	if loopThreads[player.UserId] then
		task.cancel(loopThreads[player.UserId])
		loopThreads[player.UserId] = nil
	end
end

function LeaderstatsService._startMinuteLoop(player: Player, localMinVal: IntValue)
	loopThreads[player.UserId] = task.spawn(function()
		while true do
			task.wait(59)
			localMinVal.Value += 1
		end
	end)
end


return LeaderstatsService
