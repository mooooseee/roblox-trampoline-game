--!strict
local UserInputService = game:GetService("UserInputService")
local RelicatedStorage = game:GetService("ReplicatedStorage")

local keybindRF = RelicatedStorage.Remotes.keybindRF
local sendKeybindsRE = RelicatedStorage.Remotes.sendKeybindsRE

local jumpSound = RelicatedStorage.Client.Sounds.JumpSound

local TrickController = require(RelicatedStorage.Client.Services.TrickController)

local player = game.Players.LocalPlayer
local inAir = false

--humanoid state types
local jumping = Enum.HumanoidStateType.Jumping
local freefall = Enum.HumanoidStateType.Freefall
local landed = Enum.HumanoidStateType.Landed
local running = Enum.HumanoidStateType.Running

local KeybindController = {}

local validKeybinds = {} :: {
	slotOne: Enum.KeyCode,
	slotTwo: Enum.KeyCode,
	slotThree: Enum.KeyCode,
	slotFour: {owns: boolean, KeyCode: Enum.KeyCode}
}


local function dictLen(dictionary)
	assert(type(dictionary) == "table", "not a table")
	local count = 0
	for _ in pairs(dictionary) do
		count += 1
	end
	return count
end

function KeybindController:Init()
	sendKeybindsRE.OnClientEvent:Connect(function(keybinds)
		validKeybinds = keybinds
	end)
	
	repeat
		task.wait()
	until dictLen(validKeybinds) > 0
	local humanoid: Humanoid = player.Character.Humanoid
	humanoid.StateChanged:Connect(function(old, new)
		-- Set inAir when jumping OR entering freefall (covers walking off ledges)
		if new == jumping or new == freefall then
			inAir = true
		elseif new == landed or new == running or new == Enum.HumanoidStateType.Seated then
			inAir = false
		end
	end)
	
	UserInputService.InputBegan:Connect(function(input, _gameProcesssedEvent)
		local slotName = KeybindController.isValidKeybind(validKeybinds, input.KeyCode)
		if not _gameProcesssedEvent and slotName and not TrickController.trickDebounce and inAir then
			local slot = (player:: any).slots:FindFirstChild(slotName):: BoolValue
			if slot.Value then
				local plrTrick = slot:GetAttribute("currentTrick")
				if plrTrick then
					--local trickInfo: TrickController.TrickClass = {id = plrTrick.Value, minHeight = plrTrick:GetAttribute("minHeight")}
					TrickController.handleTrick(plrTrick, slot:GetAttribute("id"), slot:GetAttribute("minHeight")) 
					print(player.Character.PrimaryPart.Position.Y)
				end
			end
		end
	end)
	
	print("KeybindController Initialized!")
end


function KeybindController.isValidKeybind(keybinds, keyCode: Enum.KeyCode): string | nil
	for slot, kb in pairs(keybinds) do
		if (slot == "slotOne" or slot == "slotTwo" or slot == "slotThree") and kb == keyCode then
			return slot
		elseif slot == "slotFour" and kb.owns and kb.KeyCode == keyCode then
			return slot
		end
	end
	return nil
end


return KeybindController
