local CollisionService = {}

--[[
	Configures the collisions for player who joined by calling setup collision function
	@param player - Player who joined the game
]]

function CollisionService.newPlayer(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	CollisionService._setUpCollisions(char)
	
	player.CharacterAdded:Connect(function(character)
		CollisionService._setUpCollisions(character)
	end)
	
	print("Collisions initialized for " .. player.UserId)
end

--[[
	Adds player's character to the Player collision group
	@param char - Player's character who needs to be added to collision group
]]

function CollisionService._setUpCollisions(char: Model)
	for _, part in char:GetDescendants() do
		if part:IsA("BasePart") then
			part.CollisionGroup = "Player"
		end
	end
end

return CollisionService