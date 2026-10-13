-- Opens/closes the Shop ScreenGui when the shop icon button is clicked

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

local iconsGui = script.Parent -- the Icons ScreenGui
local shopGui = playerGui:WaitForChild("Shop", 10)
if not shopGui then return end

local shopButton = iconsGui:FindFirstChild("shopButton", true)
local closeButton = shopGui:FindFirstChild("close", true)

-- Clicking the shop icon toggles the Flips Shop open/closed
if shopButton and shopButton:IsA("GuiButton") then
	shopButton.MouseButton1Click:Connect(function()
		shopGui.Enabled = not shopGui.Enabled
	end)
end

-- Clicking the X button closes the shop
if closeButton and closeButton:IsA("GuiButton") then
	closeButton.MouseButton1Click:Connect(function()
		shopGui.Enabled = false
	end)
end