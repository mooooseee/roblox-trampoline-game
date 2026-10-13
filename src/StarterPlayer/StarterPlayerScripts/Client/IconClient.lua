--!strict
local RelicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ButtonStyle = require(RelicatedStorage.Client.Modules.ButtonStyle)

local Icons = PlayerGui:WaitForChild("Icons")
local Buttons = Icons.Canvas.Main.Buttons

local IconClient = {}

-->Setup Style
for _, button in Buttons:GetChildren() do
	if button:IsA("GuiButton") and button.Name:match("Button$") then
		ButtonStyle.SoftButton(button)
	end
end

return IconClient
