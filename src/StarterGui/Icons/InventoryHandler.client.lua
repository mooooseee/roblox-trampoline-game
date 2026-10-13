-- Opens/closes the Inventory ScreenGui (owned flips) via the flip icon button

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

local iconsGui = script.Parent -- the Icons ScreenGui
local invGui = playerGui:WaitForChild("Inventory", 10)
if not invGui then return end

local flipButton = iconsGui:FindFirstChild("flipButton", true)
local closeButton = invGui:FindFirstChild("close", true)

-- Clicking the flip icon toggles the inventory of owned flips
if flipButton and flipButton:IsA("GuiButton") then
	flipButton.MouseButton1Click:Connect(function()
		invGui.Enabled = not invGui.Enabled
	end)
end

-- Clicking the X button closes the inventory
if closeButton and closeButton:IsA("GuiButton") then
	closeButton.MouseButton1Click:Connect(function()
		invGui.Enabled = false
	end)
end