-- Opens/closes the Settings ScreenGui when the settings icon button is clicked

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

local iconsGui = script.Parent -- the Icons ScreenGui
local settingsGui = playerGui:WaitForChild("Settings", 10)
if not settingsGui then return end

local settingButton = iconsGui:FindFirstChild("settingButton", true)
local closeButton = settingsGui:FindFirstChild("close", true)

-- Clicking the settings icon toggles the Settings menu open/closed
if settingButton and settingButton:IsA("GuiButton") then
	settingButton.MouseButton1Click:Connect(function()
		settingsGui.Enabled = not settingsGui.Enabled
	end)
end

-- Clicking the X button closes the Settings menu
if closeButton and closeButton:IsA("GuiButton") then
	closeButton.MouseButton1Click:Connect(function()
		settingsGui.Enabled = false
	end)
end
