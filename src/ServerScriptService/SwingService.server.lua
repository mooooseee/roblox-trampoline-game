local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local swing = workspace:FindFirstChild("Swing")
if not swing then return end

local seat = swing:FindFirstChild("SeatPlatform")
local hinges = {}
for _, child in ipairs(swing:GetChildren()) do
	if child:IsA("HingeConstraint") then
		table.insert(hinges, child)
	end
end
if not seat or #hinges == 0 then return end

-- Gentle idle sway, plus a kick when a player lands on the seat
local BASE_SPEED = 0.8 -- how fast it sways on its own
local BOOST_PER_LANDING = 1.2
local MAX_BOOST = 2.5
local boost = 0

-- Weld players to the seat so they get carried by the swing motion
local welds = {} -- [character] = {weld, humanoid, moveTime}
local noAttachUntil = {} -- [character] = timestamp, prevents instant re-weld after stepping off

local function removeWeld(character)
	local entry = welds[character]
	if entry then
		if entry.weld then entry.weld.Parent = nil end
		welds[character] = nil
		noAttachUntil[character] = os.clock() + 1
	end
end

local function attachPlayer(character)
	if welds[character] then return end
	if os.clock() < (noAttachUntil[character] or 0) then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp or humanoid.Health <= 0 then return end

	local weld = Instance.new("WeldConstraint")
	weld.Name = "SwingSeatWeld"
	weld.Part0 = seat
	weld.Part1 = hrp
	weld.Parent = seat

	welds[character] = {weld = weld, humanoid = humanoid, moveTime = 0}

	-- Break the weld when the player jumps so they launch off with the swing's momentum
	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall then
			removeWeld(character)
		end
	end)
end

seat.Touched:Connect(function(hit)
	local character = hit.Parent
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		boost = math.min(boost + BOOST_PER_LANDING, MAX_BOOST)
		attachPlayer(character)
	end
end)

RunService.Heartbeat:Connect(function(dt)
	-- boost fades back to idle over a few seconds
	boost = math.max(0, boost - dt * 0.6)

	local t = os.clock()
	local targetVelocity = math.cos(t * 1.1) * (BASE_SPEED + boost)
	for _, hinge in ipairs(hinges) do
		hinge.AngularVelocity = targetVelocity
	end

	-- Cleanup and let players walk off the swing
	for character, entry in pairs(welds) do
		local humanoid = entry.humanoid
		if not character.Parent or not humanoid or humanoid.Health <= 0 then
			removeWeld(character)
		else
			-- if the player holds a walk direction for a moment, release them so they can step off
			if humanoid.MoveDirection.Magnitude > 0.1 then
				entry.moveTime += dt
				if entry.moveTime > 0.3 then
					removeWeld(character)
				end
			else
				entry.moveTime = 0
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local character = player.Character
	if character then removeWeld(character) end
end)