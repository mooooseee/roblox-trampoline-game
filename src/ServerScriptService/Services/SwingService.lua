-- Handles the physics swings: when a player lands on a swing seat,
-- the swing gets a push in the direction the player was moving.

local Players = game:GetService("Players")

local SwingService = {}

-- How much swing speed (rad/s) to add when a player lands on the seat
local BOOST_PER_LANDING = 0.75
-- Cap for the scripted push so it can't be spinned up infinitely
local MAX_SWING_SPEED = 2.0
-- Minimum downward speed for a touch to count as a landing (vs. just standing)
local LANDING_FALL_SPEED = 10

-- Weak keys so destroyed characters get cleaned up automatically
local lastLanding = setmetatable({}, { __mode = "k" })

local function onSeatTouched(seat: BasePart, hit: BasePart)
	local character = hit.Parent
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Only boost on an actual landing (falling onto the seat), not while standing on it
	local velocity = root.AssemblyLinearVelocity
	if velocity.Y > -LANDING_FALL_SPEED then return end

	local now = os.clock()
	if lastLanding[character] and now - lastLanding[character] < 0.5 then return end
	lastLanding[character] = now

	-- Push in the direction the player is moving (or facing, if they dropped straight down)
	local dir = 0
	if math.abs(velocity.X) > 2 then
		dir = math.sign(velocity.X)
	else
		dir = math.sign(root.CFrame.LookVector.X)
		if dir == 0 then dir = 1 end
	end

	-- Positive angular velocity about world +Z swings the seat toward +X
	local current = seat.AssemblyAngularVelocity.Z
	local target = math.clamp(current + dir * BOOST_PER_LANDING, -MAX_SWING_SPEED, MAX_SWING_SPEED)
	seat.AssemblyAngularVelocity = Vector3.new(0, 0, target)
end

local function setupSeat(seat: BasePart)
	-- Keep the server as the owner so the landing push behaves the same for everyone
	pcall(function()
		seat:SetNetworkOwner(nil)
	end)

	seat.Touched:Connect(function(hit)
		onSeatTouched(seat, hit)
	end)
end

function SwingService.start()
	for _, inst in workspace:GetDescendants() do
		if inst:IsA("BasePart") and inst:GetAttribute("IsSwingSeat") then
			setupSeat(inst)
		end
	end
end

return SwingService