--!strict

export type TrickClass = {
	id: string, --"rbxassetid://..."
	minHeight: number,
}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local updateFlipRE = ReplicatedStorage.Remotes.updateFlipRE

local Player = game.Players.LocalPlayer
local rewardSound: Sound = script.Reward


local TrickController = {}
TrickController.__index = TrickController

TrickController.trickDebounce = false

local function showCoinReward()
	local coinUi = Player.PlayerGui.Points.Canvas.RewardFrame.coinPicture
	coinUi.Position = UDim2.new(math.random(), 0, math.random(), 0)
	print(coinUi.Position)
	local tween = TweenService:Create(coinUi, TweenInfo.new(1.3), {ImageTransparency = 1})
	coinUi.ImageTransparency = 0
	tween:Play()
	tween.Completed:Wait()
end

function TrickController.handleTrick(trickName: string, trickId: string, trickMinHeight: number)
	if TrickController._atMinHeight(trickMinHeight) and Player.Character.PrimaryPart.AssemblyLinearVelocity.Y >= 0 then
		TrickController.trickDebounce = true
		local anim = Instance.new("Animation")
		anim.AnimationId = trickId
		local track:AnimationTrack = Player.Character.Humanoid.Animator:LoadAnimation(anim)
		track:Play(0)
		updateFlipRE:FireServer(trickName)
		rewardSound:Play()
		task.delay(.2, showCoinReward)
		track.Ended:Wait()
		track:Destroy()
		TrickController.trickDebounce = false
		return true
	end
	return false
end

local function getAllCharacters()
	local chars = {}
	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr.Character then
			table.insert(chars, plr.Character)
		end
	end
	return chars
end

function TrickController._atMinHeight(minHeight: number)
	local rayParams = RaycastParams.new()
	
	-- Build a flat array for FilterDescendantsInstances
	local filterInstances = getAllCharacters()
	for _, hitbox in ipairs(CollectionService:GetTagged("hitbox")) do
		table.insert(filterInstances, hitbox)
	end
	rayParams.FilterDescendantsInstances = filterInstances
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local rayOrigin = Player.Character.PrimaryPart.Position
	local rayDir = Vector3.new(0, -100, 0)
	local rayResult = workspace:Raycast(rayOrigin, rayDir, rayParams)
	
	if rayResult and rayResult.Instance.Name == "tramp" and (rayOrigin.Y - rayResult.Position.Y) >= minHeight then
		return true
	else
		return false
	end
end

return TrickController
