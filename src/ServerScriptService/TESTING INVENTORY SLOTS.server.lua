local re = Instance.new("RemoteEvent")
re.Parent = game.ReplicatedStorage

local invSer = require(script.Parent.Services.InventoryService)
local trSer = require(script.Parent.Services.TrickService)

re.OnServerEvent:Connect(function(player, arg: string)
	local slotTwo = player.slots.slotTwo:: BoolValue
	if arg == "add" then
		local trickInfo = trSer.tricks.Frontflip
		invSer.editSlot(player, "slotTwo", "add", "Frontflip", trickInfo)
	elseif arg == "rem" then
		assert(slotTwo:GetAttribute("currentTrick") == "Frontflip", "No frontflip to remove in second slot")
		invSer.editSlot(player, "slotTwo", "rem")
	end
end)