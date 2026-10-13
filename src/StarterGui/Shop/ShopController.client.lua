--!strict
-- Populates the Flips Shop with items from FlipShopConfig and handles buying

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local buyFlipRE = Remotes:WaitForChild("buyFlipRE")
local getOwnedFlipsRF = Remotes:WaitForChild("getOwnedFlipsRF")
local pointUpdateRE = Remotes:WaitForChild("pointUpdateRE")

local FlipShopConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("FlipShopConfig"))

local player = Players.LocalPlayer
local shopGui = script.Parent
local background = shopGui:WaitForChild("Canvas"):WaitForChild("Background")
local scroll = background:WaitForChild("Main"):WaitForChild("ScrollingFrame")
local template = scroll:WaitForChild("template")

local GREEN = Color3.fromRGB(66, 181, 66)
local DARKGREEN = Color3.fromRGB(45, 130, 45)
local GRAY = Color3.fromRGB(165, 165, 165)
local RARITY_COLORS = {
	Uncommon = Color3.fromRGB(85, 255, 127),
}

local cards = {} :: {[string]: {button: TextButton, price: number, pending: boolean}}
local owned = {} :: {[string]: boolean}
local points = 0

local function updateCard(trickName: string)
	local card = cards[trickName]
	if not card then return end
	if owned[trickName] then
		card.button.Text = "Owned"
		card.button.BackgroundColor3 = DARKGREEN
		card.button.AutoButtonColor = false
	elseif points >= card.price then
		card.button.Text = "Buy"
		card.button.BackgroundColor3 = GREEN
		card.button.AutoButtonColor = true
	else
		card.button.Text = "Buy"
		card.button.BackgroundColor3 = GRAY
		card.button.AutoButtonColor = false
	end
end

local function updateAllCards()
	for trickName in pairs(cards) do
		updateCard(trickName)
	end
end

-- Build a card for every shop item
for order, item in ipairs(FlipShopConfig) do
	local card = template:Clone()
	card.Name = item.name
	card.LayoutOrder = order
	card.Visible = true
	card.icon.Image = item.image
	card.icon.ImageColor3 = RARITY_COLORS[item.rarity] or Color3.fromRGB(255, 255, 255)
	card.flipName.Text = item.name
	card.rarity.Text = item.rarity
	card.rarity.TextColor3 = RARITY_COLORS[item.rarity] or Color3.fromRGB(110, 110, 110)
	card.price.Text = if item.price == 0 then "Free" else item.price .. " pts"
	card.buyButton.Text = "Buy"
	card.Parent = scroll

	cards[item.name] = {button = card.buyButton, price = item.price, pending = false}

	card.buyButton.MouseButton1Click:Connect(function()
		local data = cards[item.name]
		if not data or data.pending or owned[item.name] then return end
		if points < data.price then
			data.button.Text = "Not enough points!"
			task.delay(1.5, function()
				updateCard(item.name)
			end)
			return
		end
		data.pending = true
		data.button.Text = "..."
		buyFlipRE:FireServer(item.name)
	end)
end

-- Initial point value (replicated from the server's otherData folder)
local otherData = player:FindFirstChild("otherData") or player:WaitForChild("otherData", 10)
if otherData then
	local pointsVal = otherData:FindFirstChild("points")
	if pointsVal and pointsVal:IsA("IntValue") then
		points = pointsVal.Value
	end
end

-- Ask the server which flips this player already owns
local function refreshOwned()
	local ok, result = pcall(function()
		return getOwnedFlipsRF:InvokeServer()
	end)
	if ok and typeof(result) == "table" then
		owned = {}
		for _, entry in ipairs(result) do
			local trickName = if typeof(entry) == "table" then entry.name else entry
			if typeof(trickName) == "string" then
				owned[trickName] = true
			end
		end
		updateAllCards()
	end
end

refreshOwned()
updateAllCards()

-- Keep affordability in sync as points change
pointUpdateRE.OnClientEvent:Connect(function(newValue)
	if typeof(newValue) == "number" then
		points = newValue
		updateAllCards()
	end
end)

-- Server response to a purchase attempt
buyFlipRE.OnClientEvent:Connect(function(trickName, success, message)
	local card = cards[trickName]
	if not card then return end
	card.pending = false
	if success then
		owned[trickName] = true
		updateCard(trickName)
	else
		card.button.Text = message or "Failed"
		task.delay(1.5, function()
			updateCard(trickName)
		end)
	end
end)

-- Re-sync the owned list every time the shop is opened
shopGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if shopGui.Enabled then
		refreshOwned()
	end
end)