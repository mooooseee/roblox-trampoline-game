--!strict
-- Populates the Inventory UI with the flips the player owns.
-- Refreshes whenever the inventory opens and right after a successful shop purchase.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local getOwnedFlipsRF = Remotes:WaitForChild("getOwnedFlipsRF")
local buyFlipRE = Remotes:WaitForChild("buyFlipRE")

local player = Players.LocalPlayer
local invGui = script.Parent
local scroll = invGui:WaitForChild("Canvas"):WaitForChild("Background"):WaitForChild("Main"):WaitForChild("ScrollingFrame")

-- Collect the slot frames (Slot1..Slot8) in order
local slots = {}
for _, child in ipairs(scroll:GetChildren()) do
	if child:IsA("Frame") then
		local num = tonumber(string.match(child.Name, "^Slot(%d+)$"))
		if num then
			slots[num] = child
			child.LayoutOrder = num
		end
	end
end

-- Make sure every slot has a name label under the icon
for _, slot in pairs(slots) do
	if not slot:FindFirstChild("flipName") then
		local label = Instance.new("TextLabel")
		label.Name = "flipName"
		label.Size = UDim2.new(1, -4, 0, 14)
		label.Position = UDim2.new(0, 2, 1, -16)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextScaled = true
		label.Text = ""
		label.Parent = slot
	end
end

local function clearSlots()
	for _, slot in pairs(slots) do
		local img = slot:FindFirstChildOfClass("ImageLabel")
		if img then img.Image = "" end
		local label = slot:FindFirstChild("flipName")
		if label then label.Text = "" end
	end
end

local function refresh()
	local ok, result = pcall(function()
		return getOwnedFlipsRF:InvokeServer()
	end)
	if not ok or typeof(result) ~= "table" then return end

	clearSlots()
	local count = 0
	for _, entry in ipairs(result) do
		if typeof(entry) ~= "table" then continue end
		count += 1
		local slot = slots[count]
		if not slot then break end
		local img = slot:FindFirstChildOfClass("ImageLabel")
		if img then img.Image = entry.image or "" end
		local label = slot:FindFirstChild("flipName")
		if label then label.Text = entry.name or "" end
	end
end

refresh()

-- Re-sync whenever the inventory is opened
invGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if invGui.Enabled then
		refresh()
	end
end)

-- A flip bought in the shop immediately appears in the inventory
buyFlipRE.OnClientEvent:Connect(function(_trickName: string, success: boolean)
	if success then
		refresh()
	end
end)