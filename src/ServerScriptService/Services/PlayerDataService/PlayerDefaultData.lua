--!strict
local PlayerDefaultData = {}

export type playerData = {
	minutes: number,
	flips: number,
}

export type playerKeybinds = {
	slotOne: Enum.KeyCode,
	slotTwo: Enum.KeyCode,
	slotThree: Enum.KeyCode,
	slotFour: {owns: boolean, KeyCode: Enum.KeyCode}
}

export type trick = {id: string, minHeight: number, points: number}

export type playerInventory = {
	[string]: trick
}

export type otherPlayerData = {
	points: number,
	personalBestEasy: number,
	peronalBestHard: number,
}

PlayerDefaultData.defaultData = {
	minutes = 0,
	flips = 0
}:: playerData

PlayerDefaultData.defaultKeybinds = {
	slotOne = Enum.KeyCode.F,
	slotTwo = Enum.KeyCode.E,
	slotThree = Enum.KeyCode.R,
	slotFour = {owns = false, KeyCode = Enum.KeyCode.C}
}:: playerKeybinds

PlayerDefaultData.defaultInventory = {
	["Backflip"] = {id = "rbxassetid://16250918536", minHeight = 27, points = 1}
}

PlayerDefaultData.defaultOtherData = {
	points = 0,
	personalBestEasy = math.huge,
	peronalBestHard = math.huge
	
}:: otherPlayerData


return PlayerDefaultData
