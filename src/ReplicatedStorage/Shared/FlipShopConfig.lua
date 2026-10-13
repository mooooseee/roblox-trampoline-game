--!strict

-- Shared shop config: used by the server (validation & pricing) and client (shop UI)
-- To add a new purchasable flip, add an entry here AND a matching entry in
-- ServerScriptService.Services.TrickService.tricks (animation id, minHeight, points per flip),
-- plus an icon in ServerScriptService.Services.InventoryService.Images.

export type ShopItem = {
	name: string,
	image: string,
	price: number,
	description: string,
	rarity: string,
}

local FlipShopConfig: {ShopItem} = {
	{name = "Backflip", image = "rbxassetid://16511417358", price = 0, description = "The classic. Everyone owns this one.", rarity = "Uncommon"},
	{name = "Frontflip", image = "rbxassetid://16511642591", price = 10, description = "Flip forward through the air. Earns 1 point per flip.", rarity = "Uncommon"},
	{name = "Sky Backflip", image = "rbxassetid://16511417358", price = 60, description = "A massive backflip. Needs 40+ studs of air. Earns 2 points per flip.", rarity = "Uncommon"},
	{name = "Sky Frontflip", image = "rbxassetid://16511642591", price = 60, description = "A massive frontflip. Needs 40+ studs of air. Earns 2 points per flip.", rarity = "Uncommon"},
}

return FlipShopConfig