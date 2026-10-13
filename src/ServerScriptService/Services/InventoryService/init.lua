--!strict 
local PlayerDataService = require(script.Parent.PlayerDataService)
local PlayerDefaultData = require(script.Parent.PlayerDataService.PlayerDefaultData)
local Images = require(script.Images)

local InventoryService = {}
InventoryService.__index = InventoryService
InventoryService._invById = {}

function InventoryService.newInv(player: Player)
	local playerInventory: PlayerDefaultData.playerInventory = PlayerDataService.LoadInventory(player)
	InventoryService._invById[player.UserId] = {}
	
	InventoryService._setupSlots(player)
	
	for trickName, trickInfo in pairs(playerInventory) do
		if trickName == "Backflip" then
			InventoryService.addTrick(player, trickName, trickInfo, (player:: any).slots.slotOne:: BoolValue)
		else
			InventoryService.addTrick(player, trickName, trickInfo)
		end
	end
	print("Inventory loaded for "..player.UserId)
end

function InventoryService.getInv(player)
	return InventoryService._invById[player.UserId]
end

function InventoryService.getInfo(player: Player, flipName: string)
	return InventoryService._invById[player.UserId].flipName
end

function InventoryService.addTrick(player: Player, trickName: string, trickInfo: PlayerDefaultData.trick, slot: BoolValue?)
	if not InventoryService._invById[player.UserId][trickName] then
		InventoryService._invById[player.UserId][trickName] = trickInfo
	end
	
	if slot then
		slot:SetAttribute("currentTrick", trickName)
		slot:SetAttribute("id", trickInfo.id)
		slot:SetAttribute("minHeight", trickInfo.minHeight)
		local newTrick = Instance.new("StringValue")
		--newTrick.Name = trickName
		--newTrick.Value = trickInfo.id
		--newTrick:SetAttribute("minHeight", trickInfo.minHeight)
		--newTrick:SetAttribute("points", trickInfo.points)
		--newTrick.Parent = slot
		slot.Value = true
	end	
end

function InventoryService._setupSlots(player: Player)
	local slotFolder = Instance.new("Folder")
	slotFolder.Parent = player
	slotFolder.Name = "slots"
	local slots = {"slotOne", "slotTwo", "slotThree", "slotFour"}
	for _, slot in ipairs(slots) do
		local newSlot = Instance.new("BoolValue")
		newSlot.Name = slot
		newSlot.Value = false
		newSlot.Parent = slotFolder
		
		newSlot.Changed:Connect(function(newValue: boolean)
			if newValue and Images[newSlot:GetAttribute("currentTrick")] then
				game.ReplicatedStorage.Remotes.slotsRE:FireClient(player, newSlot.Name, "add", Images[newSlot:GetAttribute("currentTrick")])
			end
		end)
		
		newSlot.Changed:Connect(function(value: boolean)
			if not value then
				game.ReplicatedStorage.Remotes.slotsRE:FireClient(player, newSlot.Name, "rem")
			end
		end)
	end
end

function InventoryService.editSlot(player: Player, slotName: string, arg: string, trickName: string?, trickInfoToAdd: PlayerDefaultData.trick?)
	local slotToEdit = (player:: any).slots:FindFirstChild(slotName):: BoolValue
	if slotToEdit and not slotToEdit.Value and arg == "add" and trickName and trickInfoToAdd then
		InventoryService.addTrick(player, trickName, trickInfoToAdd, slotToEdit)
	elseif slotToEdit and slotToEdit.Value and arg == "rem" then
		local trickToRemove = slotToEdit:GetAttribute("currentTrick")
		if trickToRemove then
			slotToEdit:SetAttribute("currentTrick", nil)
			slotToEdit:SetAttribute("id", nil)
			slotToEdit:SetAttribute("minHeight", nil)
			slotToEdit.Value = false
		end
	end
end

function InventoryService.CleanUp(player: Player)
	if InventoryService._invById[player.UserId] then
		InventoryService._invById[player.UserId] = nil
	end
	
	if player:FindFirstChild("slots") then
		(player:: any).slots:Destroy()
	end
end

return InventoryService
