--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local keybindRF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("keybindRF")
local sendKeybindsRE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("sendKeybindsRE")

local PlayerDataService = require(script.Parent.PlayerDataService)
local PlayerDefaultData = require(script.Parent.PlayerDataService.PlayerDefaultData) --get the keybind class
local KeybindController = require(ReplicatedStorage.Client.Services.KeybindController)
local TrickService = require(script.Parent.TrickService)
local TrickController = require(ReplicatedStorage.Client.Services.TrickController)

local KeybindService = {}
KeybindService._keybindsByUserId = {}:: {[number]: PlayerDefaultData.playerKeybinds}

--[[
	Sets up listener for the service
]]

function KeybindService.start()	
	KeybindService._listenForRemote()
	--TODO: change for players keybinds (data)
	
	print("KeybindService Started")
end

--[[
	Listens for remote function to be invoked
	@return the information of flip
]]

function KeybindService._listenForRemote()
	keybindRF.OnServerInvoke = function(player: Player, keyCode: Enum.KeyCode): TrickController.TrickClass | nil
		print(player.Name .. " fired keybindRF with keycode: " .. tostring(keyCode))
		if KeybindService._keybindsByUserId[player.UserId] then
			for slot, keybind in pairs(KeybindService._keybindsByUserId[player.UserId]) do
				if keybind == keyCode then
					print(slot)
				end
			end
		end
		--TODO check if slot is even occupied
		if keyCode == Enum.KeyCode.F then
			return TrickService.getInfoFromFlip("Backflip")
		elseif keyCode == Enum.KeyCode.E then
			return TrickService.getInfoFromFlip("Frontflip")
		end
		return nil
	end
end

--[[
	Sets up the keybinds by firing the information to player
	@param player - The player 
]]

function KeybindService.setupKeybinds(player: Player)
	local keybinds = PlayerDataService.GetKeybinds(player)
	KeybindService._keybindsByUserId[player.UserId] = keybinds
	KeybindService.sendToPlayer(player)
end

--[[
	Sends keybinds to player
	@param - The player to fire the event to
]]--

function KeybindService.sendToPlayer(player: Player)
	sendKeybindsRE:FireClient(player, KeybindService._keybindsByUserId[player.UserId])
end

return KeybindService
